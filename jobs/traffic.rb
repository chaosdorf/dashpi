# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
#SCHEDULER.every '5s', :first_in => 0 do |job|
#  #TODO
#  rx = Hash.new
#  tx = Hash.new
#  rx['value'] = JSON.parse(json)[0]['datapoints'].last()[0]
#  tx['value'] = JSON.parse(json)[1]['datapoints'].last()[0]
#  case tx['value']
#  when 0..3000000
#    tx['status'] = "normal"
#  when 3000000..4000000
#    tx['status'] = "danger"
#  else
#    tx['status'] = "warning"
#  end
#  case rx['value']
#  when 0..60000000
#    rx['status'] = "normal"
#  when 60000000..90000000
#    rx['status'] = "danger"
#  else
#    rx['status'] = "warning"
#  end
#  send_event('downlink-traffic', { value: rx['value'], status: rx['status'] })
#  send_event('uplink-traffic', { value: tx['value'], status: tx['status'] })
#end
