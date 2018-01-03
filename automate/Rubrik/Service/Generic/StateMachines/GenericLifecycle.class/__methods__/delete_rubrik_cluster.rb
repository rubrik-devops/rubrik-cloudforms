#
# Description: Catalog Item workflow for deleting Rubrik cluster
#

path = '/Rubrik/Configuration/ConfiguredClusters/'+$evm.root['dialog_cluster_name']

result = $evm.instance_delete(path)
if result
  $evm.log('info',"Instance created.")
else
  $evm.log('info',"Instance not created.")
end

$evm.root['service'].retire_now

exit MIQ_OK
