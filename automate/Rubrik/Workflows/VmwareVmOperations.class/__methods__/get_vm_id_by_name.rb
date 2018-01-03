#
# Description: Returns a Rubrik VMware VM ID by its name
#

require 'uri'
require 'net/http'
require 'openssl'
require 'json'

$evm.log(:info, "get_vm_id_by_name started")

vm_name = $evm.object['vm_name']
target_cluster = $evm.object['target_cluster']
vm_id = ''

# check a vm name has been passed
if not vm_name
  $evm.log(:warn, "No VM name provided, exiting")
  exit MIQ_STOP
end

$evm.log(:info, "Looking for VM on Rubrik with name: " + vm_name)

# get our credentials
cred_set = $evm.instantiate('/Configuration/ConfiguredClusters/'+target_cluster)

# set our credentials
servername = cred_set['rubrik_cluster']
username = cred_set['rubrik_user']
password = cred_set.decrypt('rubrik_pass')

# form and send our request
uri = '/api/v1/vmware/vm?primary_cluster_id=local&limit=20000&name=' + vm_name
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
all_vm_data = JSON.parse(response.read_body)['data']
all_vm_data.each do | vm_data |
  if vm_data['name'] == vm_name
    vm_id = vm_data['id']
  end
end
if vm_id.nil?
  $evm.log(:warn, "No VM found on Rubrik which matches the name provided")
  exit MIQ_STOP
end
$evm.log(:info, "VM found on Rubrik with ID: " + vm_id)
$evm.object['vm_id'] = vm_id
$evm.log(:info, "get_vm_id_by_name finished")
