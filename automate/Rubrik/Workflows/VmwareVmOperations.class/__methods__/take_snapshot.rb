#
# Description: Takes an on-demand VMware VM snapshot
#

require 'uri'
require 'net/http'
require 'openssl'
require 'json'

$evm.log(:info, "take_snapshot started")

vm_id = $evm.object['vm_id']
target_cluster = $evm.object['target_cluster']
sla_domain_id = $evm.object['sla_domain_id']
use_existing_sla = $evm.object['use_existing_sla']

# check a vm name has been passed
if not sla_domain_id
  $evm.log(:warn, "No SLA Domain ID provided, exiting")
  exit MIQ_STOP
end

# check a vm id has been passed
if not vm_id
  $evm.log(:warn, "No VM ID provided, exiting")
  exit MIQ_STOP
end

# create our payload
if use_existing_sla == 't'
  payload = ''
else
  payload = '{"slaId":"'+sla_domain_id+'"}'
end

# get our credentials
cred_set = $evm.instantiate('/Configuration/ConfiguredClusters/'+target_cluster)

# set our credentials
servername = cred_set['rubrik_cluster']
username = cred_set['rubrik_user']
password = cred_set.decrypt('rubrik_pass')

# form and send our request
uri = '/api/v1/vmware/vm/' + vm_id + '/snapshot'
url = URI('https://' + servername + uri)
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Post.new(url)
request.basic_auth(username, password)
request.body = payload
request['Accept'] = 'application/json'
response = http.request(request)
# check the response code is what we expect
if not response.kind_of? Net::HTTPSuccess
  $evm.log(:warn, "Something went wrong posting the payload to the Rubrik cluster, exiting")
  exit MIQ_STOP
end

# get the async request id and form our new query to check it's status
request_id = JSON.parse(response.read_body)['id']
uri = '/api/v1/vmware/vm/request/'+request_id
url = URI('https://' + servername + uri)
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Get.new(url)
request.basic_auth(username, password)
request['Accept'] = 'application/json'
response = http.request(request)
request_status = JSON.parse(response.read_body)['status']
$evm.log(:info, "request status is "+ request_status)
# loop waiting 5 seconds and checking request
while request_status == 'QUEUED' || request_status == 'RUNNING'
  sleep(5)
  response = http.request(request)
  $evm.log(:info, "request status is "+ request_status)
  request_status = JSON.parse(response.read_body)['status']
end

$evm.log(:info, "request completed, result was "+request_status)
$evm.object['result'] = request_status
$evm.log(:info, "take_snapshot finished")
exit MIQ_OK
