#
# Description: Generate a dropdown hash table of snapshots for a give VMware VM
#

require 'uri'
require 'net/http'
require 'openssl'
require 'json'

$evm.log(:info, "dd_list_vmware_vm_snapshot started")

vm = $evm.root['vm']
target_cluster = vm.custom_get('Rubrik Cluster')
vm_id = $evm.instantiate("/Rubrik/Workflows/VmwareVmOperations/GetVmIdByName?vm_name="+vm['name']+"&target_cluster="+target_cluster)['vm_id']

# check a vm id has been passed
if not vm_id
  $evm.log(:warn, "No VM name provided, exiting")
  exit MIQ_STOP
end

$evm.log(:info, "Looking for snapshots for VM ID: " + vm_id)

# get our credentials
cred_set = $evm.instantiate('/Configuration/ConfiguredClusters/'+target_cluster)

# set our credentials
servername = cred_set['rubrik_cluster']
username = cred_set['rubrik_user']
password = cred_set.decrypt('rubrik_pass')

# form and send our request
uri = '/api/v1/vmware/vm/'+vm_id+'/snapshot'
url = URI('https://' + servername + uri)
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Get.new(url)
request.basic_auth(username, password)
request['Accept'] = 'application/json'
response = http.request(request)
# check the response code is what we expect
if not response.kind_of? Net::HTTPSuccess
  $evm.log(:warn, "Something went wrong querying the Rubrik cluster, exiting")
  exit MIQ_STOP
end
all_snapshot_data = JSON.parse(response.read_body)['data']


snapshot_hash = Hash.new

all_snapshot_data.each do | snapshot_data |
  cloud_state = ''
  if snapshot_data['cloudState'] == 1
    cloud_state = ' (In Archive)'
  end
  snapshot_hash[snapshot_data['id']] = snapshot_data['date'] + cloud_state 
end

dialog_field = $evm.object

# sort_by: value / description / none
dialog_field["sort_by"] = "description"

# sort_order: ascending / descending
dialog_field["sort_order"] = "descending"

# data_type: string / integer
dialog_field["data_type"] = "string"

# required: true / false
dialog_field["required"] = "true"

dialog_field["values"] = snapshot_hash

$evm.log(:info, "dd_list_vmware_vm_snapshot finished")
exit MIQ_OK
