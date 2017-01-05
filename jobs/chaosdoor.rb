require 'mqtt'

SCHEDULER.every '5m', :allow_overlapping => false, :first_in => 0 do |job|
  MQTT::Client.connect('mqttserver') do |client|
    client.subscribe('door/status')
    client.get do |topic,message|
      send_event('chaosdoor-mode', { text: message } )
    end
  end
end
