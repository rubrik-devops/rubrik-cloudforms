#
# Description: Create an on-demand VMware VM snapshot
#

use_existing_sla = $evm.root['dialog_use_existing_sla']
target_cluster = $evm.root['dialog_select_rubrik_site']
vm_name = $evm.root['vm']['name']
sla_domain = $evm.root['dialog_sla_domain_name']

sla_domain_id = $evm.instantiate("/Rubrik/Workflows/SlaDomains/GetSlaDomainIdByName?sla_domain_name="+sla_domain+"&target_cluster="+target_cluster)
$evm.log(:info, "Returned SLA Domain ID: "+sla_domain_id['sla_domain_id'])
vm_id = $evm.instantiate("/Rubrik/Workflows/VmwareVmOperations/GetVmIdByName?vm_name="+vm_name+"&target_cluster="+target_cluster)
$evm.log(:info, "Returned VM ID: "+vm_id['vm_id'])
$evm.log(:info, "Use existing SLA set to: "+use_existing_sla)

sub_method = $evm.instantiate("/Rubrik/Workflows/VmwareVmOperations/TakeSnapshot?target_cluster="+target_cluster+"&sla_domain_id="+sla_domain_id['sla_domain_id']+"&vm_id="+vm_id['vm_id']+"&use_existing_sla="+use_existing_sla)
