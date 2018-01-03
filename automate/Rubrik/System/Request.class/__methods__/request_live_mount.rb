#
# Description: Request a Live Mount
#
vm = $evm.root['vm']
target_cluster = vm.custom_get('Rubrik Cluster')
$evm.log(:info, "Target cluster: "+target_cluster)
snapshot_id = $evm.root['dialog_snapshot']
$evm.log(:info, "Snapshot ID: "+snapshot_id)
remove_network = $evm.root['dialog_remove_network_devices']
$evm.log(:info, "Remove Network Devices: "+remove_network)

sub_method = $evm.instantiate("/Rubrik/Workflows/VmwareVmOperations/RequestVmwareVmLiveMount?target_cluster="+target_cluster+"&snapshot_id="+snapshot_id+"&remove_network="+remove_network)
