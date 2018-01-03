#
# Description: Generates a list of SLA Domains for a drop down list
#
require 'uri'
require 'net/http'
require 'openssl'
require 'json'

$evm.log(:info, "query_sla_domains started")

unless $evm.root['dialog_select_rubrik_site'].nil?
  cred_set = $evm.instantiate('/Configuration/ConfiguredClusters/'+$evm.root['dialog_select_rubrik_site'])

  servername = cred_set['rubrik_cluster']
  username = cred_set['rubrik_user']
  password = cred_set.decrypt('rubrik_pass')

  uri = '/api/v1/sla_domain?primary_cluster_id=local'
  url = URI('https://' + servername + uri)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Get.new(url)
  request.basic_auth(username, password)
  request['Accept'] = 'application/json'
  response = http.request(request)

  sla_domain_data = JSON.parse(response.read_body)['data']

  sla_hash = Hash.new

  sla_domain_data.each do | sla_domain |
    sla_hash[sla_domain['name']] = sla_domain['name']
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

  dialog_field["values"] = sla_hash
end

$evm.log(:info, "query_sla_domains finished")
exit MIQ_OK
