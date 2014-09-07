# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '5s', :first_in => 0 do |job|
  json = Net::HTTP.get('graphserver.chaosdorf.dn42', '/render/?target=scale(keepLastValue(collectd.selene_chaosdorf_dn42.snmp.if_octets-bond0_2.*),8)&format=json&from=-60seconds')
  rx = JSON.parse(json)[0]['datapoints'].last()[0]
  tx = JSON.parse(json)[1]['datapoints'].last()[0]
  send_event('downlink-traffic', { value: rx })
  send_event('uplink-traffic', { value: tx })
end
