require("uri")
require("net/http")
require("json")

uri = URI('https://vrrf.finalrewind.org/D%C3%BCsseldorf/Luisenstr.json?no_lines=4')
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Get.new(uri.request_uri)

def json_to_data(data)
  return {
    :time => data[2],
    :line => data[0],
    :dest => data[1].gsub("D-", "") # remove "D-"
  }
end

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  begin
    json = JSON.parse(http.request(request).body)
    pre = json["preformatted"]
    data = {
      :t1 => json_to_data(pre[0]),
      :t2 => json_to_data(pre[1]),
      :t3 => json_to_data(pre[2]),
      :t4 => json_to_data(pre[3]),
      :status => "normal"
    }
    if data[:t1][:time] == "sofort"
      data[:status] = "warning"
    end
    send_event('efa', data)
  rescue
    send_event('efa', { status: "danger" })
  end
end
