#
# Description: Returns a Rubrik vCenter ID by its name
#

require 'uri'
require 'net/http'
require 'openssl'
require 'json'

$evm.log(:info, "get_vcenter_id_by_name started")

vcenter_name = $evm.object['vcenter_name']
target_cluster = $evm.object['target_cluster']
vcenter_id = ''

$evm.log(:info, "Looking for vCenter on Rubrik with name: " + vcenter_name)

# check a vcenter id has been passed
if not vcenter_name
  $evm.log(:warn, "No vCenter name provided, exiting")
  exit MIQ_STOP
end

# get our credentials
cred_set = $evm.instantiate('/Configuration/ConfiguredClusters/'+target_cluster)

# set our credentials
servername = cred_set['rubrik_cluster']
username = cred_set['rubrik_user']
password = cred_set.decrypt('rubrik_pass')

# form and send our refresh request
uri = '/api/v1/vmware/vcenter?primary_cluster_id=local'
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
all_vcenter_data = JSON.parse(response.read_body)['data']
# iterate through until we get the vCenter we want
all_vcenter_data.each do | vcenter_data |
  if vcenter_data['name'] == vcenter_name
    vcenter_id = vcenter_data['id']
  end
end
if vcenter_id.nil?
  $evm.log(:warn, "No vCenter found on Rubrik which matches the name provided")
  exit MIQ_STOP
end
$evm.log(:info, "vCenter found on Rubrik with ID: " + vcenter_id)
$evm.object['vcenter_id'] = vcenter_id
$evm.log(:info, "get_vcenter_id_by_name finished")
