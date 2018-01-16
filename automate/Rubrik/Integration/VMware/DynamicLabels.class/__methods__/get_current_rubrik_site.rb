#
# Description: Returns the currently configured Rubrik cluster
#
$evm.log(:info, "get_current_rubrik_site started")
vm = $evm.root['vm']
current_cluster = vm.custom_get('Rubrik Cluster')
if not current_cluster
  current_cluster = 'None'
end
$evm.log(:info, "Current cluster: "+current_cluster)
dialog_field = $evm.object
dialog_field["value"] = current_cluster
$evm.log(:info, "get_current_rubrik_site finished")
exit MIQ_OK
