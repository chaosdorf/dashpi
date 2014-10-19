# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  json = Net::HTTP.get('collectd.rheinufer.freifunk-rheinland.net', '/render/?target=maxSeries(keepLastValue(collectd.rheinufer*.batman.gauge-nodes))&from=-1minute&format=json')
  value = JSON.parse(json)[0]['datapoints'][0][0]
  send_event('freifunk-total', { current: value })
end
