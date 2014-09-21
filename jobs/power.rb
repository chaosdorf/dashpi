# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1s', :first_in => 0 do |job|
  sensors = ['d80587d41bebde066f003a8f60ac0d01','2267a0503927a5f2bbf0050f657dcc55','90d083c153310b5787e3f1a7fc7967a5']
  value = 0
  (0..2).each do |i|
    json = Net::HTTP.get('flukso.chaosdorf.dn42',"/sensor/#{sensors[i]}?version=1.0&interval=minute&unit=watt&callback=realtime",'8080')
    value += JSON.parse(json)[-2][1].to_i
  end
  send_event('power-total', { current: value })
end
