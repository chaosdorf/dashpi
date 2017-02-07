require("uri")
require("net/http")
require("json")

uri = URI('https://map.freifunk-duesseldorf.de/data/nodes.json')
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Get.new(uri.request_uri)

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  begin
    json = JSON.parse(http.request(request).body)
    value = json["nodes"].length()
    send_event('freifunk-total', { current: value, status: "normal" })
  rescue
    send_event('freifunk-total', { current: 0, status: "warning" })
  end
end
