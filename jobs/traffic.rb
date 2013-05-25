# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '5m', :first_in => 0 do |job|
  json = Net::HTTP.get('graphserver.chaosdorf.dn42', '/render/?target=movingMedian(derivative(keepLastValue(scale(servers.dn42.chaosdorf.figurehead.network.if_inet.up,0.08))),5)&from=-5minutes&format=json')
  value = JSON.parse(json)[0]['datapoints'].last[0]
  if value
    send_event('uplink-traffic', { value: value.to_i })
    puts "Uplink Traffic: #{value}"
  else
    puts "Uplink Traffic: #{value}"
  end
  json = Net::HTTP.get('graphserver.chaosdorf.dn42', '/render/?target=movingMedian(derivative(keepLastValue(scale(servers.dn42.chaosdorf.figurehead.network.if_inet.down,0.08))),5)&from=-5minutes&format=json')
  value = JSON.parse(json)[0]['datapoints'].last[0]
  if value
    send_event('downlink-traffic', { value: value.to_i })
    puts "Downlink Traffic: #{value}"
  else
    puts "Downlink Traffic: (error)"
  end
end
