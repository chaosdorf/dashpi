# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  json = Net::HTTP.get('ffmap.freifunk-rheinland.net', '/alfred_merged.json')
  value = json.split("\n").grep(/node_id/).length()
  send_event('freifunk-total', { current: value })
end
