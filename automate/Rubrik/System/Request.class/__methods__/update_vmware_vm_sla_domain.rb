#
# Description: Updates the SLA Domain for a given VM
#
$evm.log(:info, "update_vmware_vm_sla_domain started")
# Get the VM object
vm = $evm.root['vm']
target_cluster = $evm.root['dialog_select_rubrik_site']
sla_domain = $evm.root['dialog_sla_domain_list']

# get vm id and sla domain id
vm_id = $evm.instantiate("/Rubrik/Workflows/VmwareVmOperations/GetVmIdByName?vm_name="+vm['name']+"&target_cluster="+target_cluster)
$evm.log(:info, "Returned VM ID: "+vm_id['vm_id'])
sla_domain_id = $evm.instantiate("/Rubrik/Workflows/SlaDomains/GetSlaDomainIdByName?sla_domain_name="+sla_domain+"&target_cluster="+target_cluster)
$evm.log(:info, "Returned SLA Domain ID: "+sla_domain_id['sla_domain_id'])

# patch the vm to set the SLA domain
payload = '{"configuredSlaDomainId":"'+sla_domain_id['sla_domain_id']+'"}'

# set protection
set_policy = $evm.instantiate("/Rubrik/Workflows/VmwareVmOperations/PatchVmwareVm?vm_id="+vm_id['vm_id']+"&payload="+payload+"&target_cluster="+target_cluster)

# Set the custom attributes
vm.custom_set('Rubrik SLA Domain', $evm.root['dialog_sla_domain_list'])
vm.custom_set('Rubrik Cluster', $evm.root['dialog_select_rubrik_site'])
$evm.log(:info, "update_vmware_vm_sla_domain finished")
exit MIQ_OK
