#
# Description: Refreshes a vCenter server
#

require 'uri'
require 'net/http'
require 'openssl'
require 'json'

$evm.log(:info, "refresh_vcenter started")

vcenter_id = $evm.object['vcenter_id']
target_cluster = $evm.object['target_cluster']

# check a vcenter id has been passed
if not vcenter_id
  $evm.log(:warn, "No vCenter ID provided, exiting")
  exit MIQ_STOP
end

# get our credentials
cred_set = $evm.instantiate('/Configuration/ConfiguredClusters/'+target_cluster)

# set our credentials
servername = cred_set['rubrik_cluster']
username = cred_set['rubrik_user']
password = cred_set.decrypt('rubrik_pass')

# form and send our refresh request
uri = '/api/v1/vmware/vcenter/' + vcenter_id + '/refresh'
url = URI('https://' + servername + uri)
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Post.new(url)
request.basic_auth(username, password)
request['Accept'] = 'application/json'
response = http.request(request)
# check the response code is what we expect
if not response.kind_of? Net::HTTPSuccess
  $evm.log(:warn, "Something went wrong refreshing vCenter, exiting")
  exit MIQ_STOP
end

# get the async request id and form our new query to check it's status
request_id = JSON.parse(response.read_body)['id']
uri = '/api/v1/vmware/vcenter/request/'+request_id
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
$evm.object['result'] = request_status
$evm.log(:info, "request completed, result was "+request_status)
$evm.log(:info, "refresh_vcenter finished")
exit MIQ_OK
