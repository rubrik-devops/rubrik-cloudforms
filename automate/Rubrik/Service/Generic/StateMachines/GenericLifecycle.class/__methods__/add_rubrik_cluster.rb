#
# Description: Adds a new Rubrik cluster to '/Configuration/ConfiguredClusters'
#

path = '/Rubrik/Configuration/ConfiguredClusters/'+$evm.root['dialog_cluster_name']

hash = { 
  "rubrik_cluster" => $evm.root['dialog_rubrik_host'],
  "rubrik_user" => $evm.root['dialog_rubrik_user'],
  "rubrik_pass" => $evm.root['dialog_rubrik_pass'],
  "execute"	=> nil
  }

result = $evm.instance_create(path, hash)
if result
  $evm.log('info',"Instance created.")
else
  $evm.log('info',"Instance not created.")
end

# commenting out, see https://github.com/rubrik-devops/rubrik-cloudforms/issues/2
#$evm.root['service'].retire_now

exit MIQ_OK
