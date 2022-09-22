require 'prometheus/api_client'

prometheus = Prometheus::ApiClient.client(url: ENV['PROMETHEUS_URL'])

def query(prometheus, q)
  res = prometheus.query(query: "rate(if#{q}Octets{ifDescr=\"eth1\"}[2m])")
  res['result'][0]['value'][1].to_f * 8
end

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '5s', :first_in => 0 do |job|
  rx = Hash.new
  tx = Hash.new
  rx['value'] = query(prometheus, 'In')
  tx['value'] = query(prometheus, 'Out')
  case tx['value']
  when 0..25000000
    tx['status'] = "normal"
  when 25000000..37500000
    tx['status'] = "danger"
  else
    tx['status'] = "warning"
  end
  case rx['value']
  when 0..500000000
    rx['status'] = "normal"
  when 500000000..750000000
    rx['status'] = "danger"
  else
    rx['status'] = "warning"
  end
  send_event('downlink-traffic', { value: rx['value'], status: rx['status'] })
  send_event('uplink-traffic', { value: tx['value'], status: tx['status'] })
end
