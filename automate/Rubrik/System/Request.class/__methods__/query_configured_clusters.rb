#
# Description: Returns a list of configured Rubrik clusters
#
$evm.log(:info, "query_configured_clusters started")

out_hash = Hash.new
result = $evm.instance_find("/Rubrik/Configuration/ConfiguredClusters/*")
result.each do | instance |
  out_hash[instance[0]] = instance[0]
end

dialog_field = $evm.object

# sort_by: value / description / none
dialog_field["sort_by"] = "value"

# sort_order: ascending / descending
dialog_field["sort_order"] = "ascending"

# data_type: string / integer
dialog_field["data_type"] = "string"

# required: true / false
dialog_field["required"] = "true"

dialog_field["values"] = out_hash

$evm.log(:info, "query_configured_clusters finished")
exit MIQ_OK
