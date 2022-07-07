# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  url = "https://cat.pics.marudor.de/thumb?#{Time.now}"
  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri, { 'User-Agent': 'chaosdorf/dashpi' })
  res = http.request(request).response
  case res
  when Net::HTTPSuccess then
    if res.content_length > 20000000 then
      send_event('cat', { image: url })
    else
      send_event('cat', { image: 'data:image/jpeg;base64,' + Base64.strict_encode64(res.body) })
    end
  else
    send_event('cat', {})
  end
end
