#
# Description: Configures and protects a new VM provisioned
#
$evm.log(:info, "protect_new_vm started")

prov = $evm.root["miq_provision"]
# have to get the options and convert to json and back or can't seem to grab the src_ems_id properly
options_json = JSON.generate(prov.options())
options = JSON.parse(options_json)

target_cluster = prov.get_option(:select_rubrik_site)
sla_domain = prov.get_option(:sla_domain_list)
vcenter_name = options['src_ems_id'][1]
vm_name = prov.get_option(:vm_target_name)

$evm.log(:info, "Selected SLA Domain: "+sla_domain)
$evm.log(:info, "Selected Rubrik site: "+target_cluster)
$evm.log(:info, "VM Name: "+vm_name)
$evm.log(:info, "vCenter Name: "+vcenter_name)

# get vcenter id
if vcenter_name
  vcenter_id = $evm.instantiate("/Rubrik/Workflows/VmwareVcenterOperations/GetVcenterIdByName?vcenter_name="+vcenter_name+"&target_cluster="+target_cluster)
  $evm.log(:info, "vCenter ID returned as: "+vcenter_id['vcenter_id'])
else
  $evm.log(:warn, "vCenter name not specified")
end

# refresh vcenter
if vcenter_id
  refresh_vcenter = $evm.instantiate("/Rubrik/Workflows/VmwareVcenterOperations/RefreshVcenter?vcenter_id="+vcenter_id['vcenter_id']+"&target_cluster="+target_cluster)
  $evm.log(:info, "Refreshed vCenter with result: "+refresh_vcenter['result'])
else
  $evm.log(:warn, "vCenter ID not received")
end

# get vm id and sla domain id
if vm_name
  vm_id = $evm.instantiate("/Rubrik/Workflows/VmwareVmOperations/GetVmIdByName?vm_name="+vm_name+"&target_cluster="+target_cluster)
  $evm.log(:info, "Returned VM ID: "+vm_id['vm_id'])
else
  $evm.log(:warn, "VM name not specified")
end

if sla_domain
  sla_domain_id = $evm.instantiate("/Rubrik/Workflows/SlaDomains/GetSlaDomainIdByName?sla_domain_name="+sla_domain+"&target_cluster="+target_cluster)
  $evm.log(:info, "Returned SLA Domain ID: "+sla_domain_id['sla_domain_id'])
else
  $evm.log(:warn, "SLA Domain name not specified")
end

if vm_id['vm_id'] && sla_domain_id['sla_domain_id']
  # patch the vm to set the SLA domain
  payload = '{"configuredSlaDomainId":"'+sla_domain_id['sla_domain_id']+'"}'

  # set protection
  set_policy = $evm.instantiate("/Rubrik/Workflows/VmwareVmOperations/PatchVmwareVm?vm_id="+vm_id['vm_id']+"&payload="+payload+"&target_cluster="+target_cluster)
  $evm.log(:info, "Protected VM with SLA Domain "+sla_domain)
else
  $evm.log(:warn, "SLA Domain ID and/or VM ID not specified")
end
  
# get vm
vm = $evm.vmdb('vm').find_by_name(vm_name)
if vm
  # Set the custom attributes
  add_sla_domain_tag = vm.custom_set('Rubrik SLA Domain', sla_domain)
  add_cluster_tag = vm.custom_set('Rubrik Cluster', target_cluster)
  $evm.log(:info, "Added custom attributes: "+sla_domain+","+target_cluster)
else
  $evm.log(:warn, "VM object not found")
end

$evm.log(:info, "protect_new_vm finished")
exit MIQ_OK
