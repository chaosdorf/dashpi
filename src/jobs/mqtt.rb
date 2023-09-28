require 'mqtt'

power_series = Array.new(20).fill(0)
music_status = {}
last_music_update = Time.now
last_dorfstatus = "unknown"

SCHEDULER.every '5m', :allow_overlapping => false, :first_in => 0 do |job|
    client = MQTT::Client.new
    client.host = ENV['MOSQUITTO_HOST']
    client.ack_timeout = 15 # default is 5
    client.keep_alive = 90 # default is 15
    client.client_id = 'dashboard-' + (settings.environment == :development ? 'dev' : 'prod')
    client.clean_session = false
    puts "mqtt: connecting to #{client.host} as #{client.client_id}..."
    client.connect()
    puts "mqtt: connected to #{client.host} as #{client.client_id}."
    
    client.subscribe('sensors/flukso/power/sum/30s_average') # power
    client.subscribe('space/dorfstatus')
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
      elsif topic == 'space/dorfstatus'
        ##################################
        # D O R F                        #
        ##################################
        last_dorfstatus = message
        send_event('dorfstatus', { text: message, status: "normal" } )
      elsif topic == 'space/bell' # message is 'ringdingding'
        ##################################
        # R I N G                        #
        ##################################
        send_event('dorfstatus', { text: message, status: "danger" } )
        SCHEDULER.in '10s' do
          send_event('dorfstatus', { text: last_dorfstatus, status: "normal" } )
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
    client.disconnect() # TODO: does this make sense?
end
