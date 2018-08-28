# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
require 'net/ping/tcp'

series = Array.new(20).fill(0)

SCHEDULER.every '5s', :first_in => 0 do |job|
  probe = Net::Ping::TCP.new(ENV['PING_HOST'])
  probe.port = 80
  probe.ping
  begin
    value = (probe.duration * 1000).round()
    status = "normal"
    series[0] = value
    case value
    when 0..100
      status = "normal"
    when 100..200
      status = "danger"
    else
      status = "warning"
    end
    down = false
  rescue NoMethodError
    status = "warning"
    series[0] = 0
    down = true
  end
  series.rotate!
  data = series.map.with_index{ |n,i| {"x" => -i, "y" => n} }
  send_event('ping', { points: data, status: status, moreinfo: "$ ping #{ENV['PING_HOST']} #{down ? "is down" : ""}" })

end
