# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '5m', :first_in => 0 do |job|
  json = Net::HTTP.get('graphserver.chaosdorf.dn42', '/render/?target=movingMedian(keepLastValue(servers.dn42.chaosdorf.figurehead.network.online_ips.dynip),5)&format=json&from=-5minutes')
  value = JSON.parse(json)[0]['datapoints'].last[0]
  if value
    send_event('dynip', { current: value.to_i })
  end
end
