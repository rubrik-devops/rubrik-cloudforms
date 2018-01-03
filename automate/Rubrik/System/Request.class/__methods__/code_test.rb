#
# Description: Lists available instances
#
=begin
out_array = Array.new

result = $evm.instance_find("/Rubrik/Configuration/ConfiguredClusters/*")
result.each do | instance |
  #$evm.log(:info, instance[0])
  out_array.push(instance[0])
end
out_array.sort!
$evm.log(:info, out_array)

sub_method = $evm.instantiate("/Rubrik/Workflows/VmwareVcenterOperations/RefreshVcenter?vcenter_id=vCenter:::884de08c-3e1c-4824-8a15-413b4e85266c&target_cluster=devops-1.rangers.lab")
if sub_method.nil?
  $evm.log("info", "something went wrong with the instantiation")
else
  $evm.log("info","result is #{sub_method['result']}")
end
=end
vm = $evm.vmdb('vm').find_by_name('th-miq-test123')
$evm.log(:info, vm.name)
