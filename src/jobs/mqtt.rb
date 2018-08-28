require 'mqtt'

power_series = Array.new(20).fill(0)
music_status = {}
last_music_update = Time.now
last_door_state = "unknown"

SCHEDULER.every '5m', :allow_overlapping => false, :first_in => 0 do |job|
  MQTT::Client.connect(ENV['MOSQUITTO_HOST']) do |client|
    client.subscribe('sensors/flukso/power/sum/30s_average') # power
    client.subscribe('door/status') # door
    client.subscribe('space/bell') # door bell
    client.subscribe('music/#') # music

    client.get do |topic,message|
      message = message.force_encoding('utf-8')
      if topic == 'sensors/flukso/power/sum/30s_average'
        ##################################
        # P O W E R                      #
        ##################################
        value = Float(message).round
        power_series[0] = value
        power_series.rotate!
        case value
        when 0..1500
          status = "normal"
        when 1500..3000
          status = "danger"
        else
          status = "warning"
        end
        data = power_series.map.with_index{ |n,i| {"x" => -i, "y" => n} }
        send_event('power-total', { points: data, status: status, moreinfo: "total power consumption" })
      elsif topic == 'door/status'
        ##################################
        # D O O R                        #
        ##################################
        last_door_state = message
        send_event('chaosdoor-mode', { text: message, status: "normal" } )
      elsif topic == 'space/bell' # message is 'ringdingding'
        ##################################
        # R I N G                        #
        ##################################
        send_event('chaosdoor-mode', { text: message, status: "danger" } )
        SCHEDULER.in '10s' do
          send_event('chaosdoor-mode', { text: last_door_state, status: "normal" } )
        end
      elsif topic.start_with?('music/')
        ##################################
        # M U S I C                      #
        ##################################
        music_status['music-'+topic.split('/')[1]] = message
        if last_music_update < (Time.now - 5)
          last_music_update = Time.now
          SCHEDULER.in '1s' do
            send_event('music', music_status.clone)
          end
        end
      end
    end
  end
end
