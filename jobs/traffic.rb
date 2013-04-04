# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '10s', :first_in => 0 do |job|
  json = Net::HTTP.get('graphserver', '/render/?target=scale(summarize(derivative(servers.dn42.chaosdorf.figurehead.network.if_inet.up),"10minutes"),0.1))&from=-10minutes&format=json')
  value = JSON.parse(json)[0]['datapoints'][0][0]
  if value
    send_event('uplink-traffic', { value: value })
    puts "Uplink Traffic: #{value}"
  else
    puts "Uplink Traffic: #{value}"
  end
  json = Net::HTTP.get('graphserver', '/render/?target=scale(summarize(derivative(servers.dn42.chaosdorf.figurehead.network.if_inet.down),"10minutes"),0.1))&from=-10minutes&format=json')
  value = JSON.parse(json)[0]['datapoints'][0][0]
  if value
    send_event('downlink-traffic', { value: value })
    puts "Downlink Traffic: #{value}"
  else
    puts "Downlink Traffic: (error)"
  end
end
