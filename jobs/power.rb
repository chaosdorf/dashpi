# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
sensors = ['d80587d41bebde066f003a8f60ac0d01','2267a0503927a5f2bbf0050f657dcc55','90d083c153310b5787e3f1a7fc7967a5']
data = Array.new(5)
SCHEDULER.every '1s', :first_in => 0 do |job|
  data.rotate!
  sensors.each do |sensor|
    json = Net::HTTP.get('flukso.chaosdorf.dn42',"/sensor/#{sensor}?version=1.0&interval=minute&unit=watt&callback=realtime",'8080')
    5.times do |i|
      data[i] = { "x" => -i, "y" => JSON.parse(json)[-2 - i][1].to_i }
    end
  end
  case data[0]
  when 0..1500
    status = "normal"
  when 1500..3000
    status = "danger"
  else
    status = "warning"
  end
  send_event('power-total', { points: data, status: status, moreinfo: "total power consumption" })
end
