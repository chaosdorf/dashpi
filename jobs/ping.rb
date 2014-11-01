# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
require 'net/ping/tcp'

host = "80.69.100.220" # speedtest.unitymedia.de
last = 0

SCHEDULER.every '5s', :first_in => 0 do |job|
  probe = Net::Ping::TCP.new(host)
  probe.port = 80
  probe.ping
  value = (probe.duration * 1000).round()
  status = "normal"
  case value
  when 0..100
    status = "normal"
  when 100..200
    status = "danger"
  else
    status = "warning"
  end
  send_event('ping', { current: value, last: last, status: status })
  last = value
end
