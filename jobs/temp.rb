SCHEDULER.every '2s', :first_in => 0 do
  json = Net::HTTP.get('graphserver', '/render/?target=movingMedian(offset(stats.gauges.foobar.temperature,-4),2)&from=-10minutes&format=json')
  value = JSON.parse(json)[0]['datapoints'][1][0]
  puts "Hackcenter Temperature: #{value}"
  send_event('temp', value: value)
end
