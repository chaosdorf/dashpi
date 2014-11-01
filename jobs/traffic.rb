# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '5s', :first_in => 0 do |job|
  json = Net::HTTP.get('graphserver.chaosdorf.dn42', '/render/?target=scale(keepLastValue(collectd.selene_chaosdorf_dn42.snmp.if_octets-bond0_2.*),8)&format=json&from=-60seconds')
  rx = Hash.new
  tx = Hash.new
  rx['value'] = JSON.parse(json)[0]['datapoints'].last()[0]
  tx['value'] = JSON.parse(json)[1]['datapoints'].last()[0]
  case tx['value']
  when 0
    tx['status'] = "danger"
  when 0..5000000
    tx['status'] = "normal"
  else
    tx['status'] = "warning"
  end
  case rx['value']
  when 0
    rx['status'] = "danger"
  when 0..100000000
    rx['status'] = "normal"
  else
    rx['status'] = "warning"
  end
  send_event('downlink-traffic', { value: rx['value'], status: rx['status'] })
  send_event('uplink-traffic', { value: tx['value'], status: tx['status'] })
end
