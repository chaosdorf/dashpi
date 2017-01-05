require 'mqtt'

series = Array.new(20).fill(0)

SCHEDULER.every '5m', :allow_overlapping => false, :first_in => 0 do |job|
  MQTT::Client.connect('mqttserver') do |client|
    client.subscribe('sensors/flukso/power/sum/30s_average')
    client.get do |topic,message|
      series.rotate!
      value = Float(message).round
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
  end
end
