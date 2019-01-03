#
# Description: Returns the currently configured Rubrik SLA
#
$evm.log(:info, "get_current_rubrik_sla started")
vm = $evm.root['vm']
current_sla = vm.custom_get('Rubrik SLA Domain')
if not current_sla
  current_sla = 'None'
end
$evm.log(:info, "Current SLA: "+current_sla)
dialog_field = $evm.object
dialog_field["value"] = current_sla
$evm.log(:info, "get_current_rubrik_sla finished")
exit MIQ_OK
