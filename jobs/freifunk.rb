# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  json = Net::HTTP.get('graphserver', '/render/?target=keepLastValue(servers.dn42.chaosdorf.figurehead.network.freifunk_nodes.total)&from=-24hours&until&format=json')
  values = JSON.parse(json)[0]['datapoints']
  points = values.collect { |value|
    y = value[0]
    x = value[1]
    { :x => y, :y => y }
  }
  send_event('freifunk-total', { points: points })
  puts "Freifunk Total: #{values.last[0]}"
end
