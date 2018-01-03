#
# Description: Returns a Rubrik SLA Domain ID by its name
#

require 'uri'
require 'net/http'
require 'openssl'
require 'json'

$evm.log(:info, "get_sla_domain_id_by_name started")

sla_domain_name = $evm.object['sla_domain_name']
target_cluster = $evm.object['target_cluster']
sla_domain_id = ''

$evm.log(:info, "Looking for SLA domain on Rubrik with name: " + sla_domain_name)

# check a SLA domain name has been passed
if not sla_domain_name
  $evm.log(:warn, "No SLA domain name provided, exiting")
  exit MIQ_STOP
end

# get our credentials
cred_set = $evm.instantiate('/Configuration/ConfiguredClusters/'+target_cluster)

# set our credentials
servername = cred_set['rubrik_cluster']
username = cred_set['rubrik_user']
password = cred_set.decrypt('rubrik_pass')

# form and send our refresh request
uri = '/api/v1/sla_domain?primary_cluster_id=local&name=' + sla_domain_name
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
all_sla_domains = JSON.parse(response.read_body)['data']
# iterate through until we get the SLA domain we want
all_sla_domains.each do | sla_domain |
  if sla_domain['name'] == sla_domain_name
    sla_domain_id = sla_domain['id']
  end
end
if sla_domain_id.nil?
  $evm.log(:warn, "No SLA Domain found on Rubrik which matches the name provided")
  exit MIQ_STOP
end
$evm.log(:info, "SLA Domain found on Rubrik with ID: " + sla_domain_id)
$evm.object['sla_domain_id'] = sla_domain_id
$evm.log(:info, "get_sla_domain_id_by_name finished")
