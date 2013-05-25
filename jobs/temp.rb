SCHEDULER.every '10s', :first_in => 0 do
  json = Net::HTTP.get('graphserver.chaosdorf.dn42', '/render/?target=offset(stats.gauges.foobar.temperature,-4)&from=-2minutes&format=json')
  current = JSON.parse(json)[0]['datapoints'][0][0]
  last = JSON.parse(json)[0]['datapoints'][1][0]
  puts "Hackcenter Temperature: #{current} (#{last})"
  send_event('temp', current: current, last: last)
end
