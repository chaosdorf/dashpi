require_relative 'lib/flukso'

SCHEDULER.every '1s', :first_in => 0 do |job|
  data = get_power_values 
  case data.last
  when 0..1500
    status = "normal"
  when 1500..3000
    status = "danger"
  else
    status = "warning"
  end
  puts data.inspect()
  send_event('power-total', { points: data, status: status, moreinfo: "total power consumption" })
end
