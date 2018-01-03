#
# Description: Stores a new Rubrik cluster's details
#

require 'uri'
require 'net/http'
require 'openssl'
require 'json'

$evm.log(:info, "get_cluster_info started")

cred_set = $evm.instantiate('/Configuration/ConfiguredClusters/devops-1.rangers.lab')

servername = cred_set['rubrik_cluster']
username = cred_set['rubrik_user']
password = cred_set.decrypt('rubrik_pass')

uri = '/api/v1/cluster/me'
url = URI('https://' + servername + uri)
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Get.new(url)
request.basic_auth(username, password)
request['Accept'] = 'application/json'
response = http.request(request)
if response.code == '422'
  puts 'Invalid credentials detected, please retry'
  exit
end
$evm.log(:info, "Response: "+response.read_body)
$evm.log(:info, "get_cluster_info finished")
exit MIQ_OK
