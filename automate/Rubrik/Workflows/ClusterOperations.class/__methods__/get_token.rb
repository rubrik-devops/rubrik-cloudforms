#
# Description: Stores a new Rubrik cluster's details
#

require 'uri'
require 'net/http'
require 'openssl'
require 'json'

$evm.log(:info, "get_token started")

cred_set = $evm.instantiate('/Configuration/ConfiguredClusters/devops-1.rangers.lab')

servername = cred_set['rubrik_cluster']
username = cred_set['rubrik_user']
password = cred_set.decrypt('rubrik_pass')

uri = '/api/v1/session'
url = URI('https://' + servername + uri)
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Post.new(url)
request.basic_auth(username, password)
request['Accept'] = 'application/json'
request.body = '{"username":"'+username+'","password":"'+password+'"}'
response = http.request(request)
token = JSON.parse(response.read_body)['token']
$evm.log(:info, "Setting rubrik_token value to: " + token)
$evm.object['rubrik_token'] = token
$evm.log(:info, "get_token finished")
exit MIQ_OK
