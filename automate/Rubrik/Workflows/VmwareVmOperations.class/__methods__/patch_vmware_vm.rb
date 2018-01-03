#
# Description: Runs a PATCH request against a specified VMware VM
#

require 'uri'
require 'net/http'
require 'openssl'
require 'json'

$evm.log(:info, "patch_vmware_vm started")

vm_id = $evm.object['vm_id']
target_cluster = $evm.object['target_cluster']
payload = $evm.object['payload']

# check a vm id has been passed
if not vm_id
  $evm.log(:warn, "No VM ID provided, exiting")
  exit MIQ_STOP
end

# create our payload
if not payload
  $evm.log(:warn, "No payload provided, exiting")
  exit MIQ_STOP
end

# get our credentials
cred_set = $evm.instantiate('/Configuration/ConfiguredClusters/'+target_cluster)

# set our credentials
servername = cred_set['rubrik_cluster']
username = cred_set['rubrik_user']
password = cred_set.decrypt('rubrik_pass')

# form and send our request
uri = '/api/v1/vmware/vm/' + vm_id
url = URI('https://' + servername + uri)
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Patch.new(url)
request.basic_auth(username, password)
request.body = payload
request['Accept'] = 'application/json'
response = http.request(request)
# check the response code is what we expect
if not response.kind_of? Net::HTTPSuccess
  $evm.log(:warn, "Something went wrong posting the payload to the Rubrik cluster, exiting")
  exit MIQ_STOP
end

$evm.log(:info, "patch_vmware_vm finished")
exit MIQ_OK
