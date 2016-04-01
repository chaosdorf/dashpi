require 'net/http'

series = Array.new(20).fill(0)

SCHEDULER.every '30s', :first_in => 0 do |job|
  series.rotate!
  response = Net::HTTP.get('feedback.chaosdorf.dn42', '/flukso/30')
  value = Float(response).round
	series[0] = value
  case value
  when 0..1500
    status = "normal"
  when 1500..3000
    status = "danger"
  else
    status = "warning"
  end
  data = series.map.with_index{ |n,i| {"x" => -i, "y" => n} }
  send_event('power-total', { points: data, status: status, moreinfo: "total power consumption" })
end
