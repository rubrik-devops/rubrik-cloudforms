#
# Description: Adds a new Rubrik cluster to '/Configuration/ConfiguredClusters'
#

path = '/Rubrik/Configuration/ConfiguredClusters/test'

hash = { 
  "rubrik_cluster" => "rubrik.test.com",
  "rubrik_user" => "admin",
  "rubrik_pass" => "something",
  "execute"	=> nil
  }

result = $evm.instance_create(path, hash)
if result
  $evm.log('info',"Instance created.")
else
  $evm.log('info',"Instance not created.")
end
