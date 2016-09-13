# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  url = "https://maurudor.de/thumb?#{Time.now}"
  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  resp = http.request(request).response
  case resp
  when Net::HTTPSuccess then
    send_event('cat', { image: url })
  else
    send_event('cat', {})
  end
end
