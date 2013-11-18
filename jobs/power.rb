# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  json = Net::HTTP.get('graphserver.chaosdorf.dn42', '/render?from=-10minutes&target=sum(keepLastValue(collectd.figurehead_chaosdorf_dn42.tail-power.gauge-phase_*))&format=json')
  value = JSON.parse(json)[0]['datapoints'].last()[0].to_i
  send_event('power-total', { current: value })
  puts value
end
