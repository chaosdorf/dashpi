require("uri")
require("net/http")
require("json")

uri = URI('https://vrrf.finalrewind.org/D%C3%BCsseldorf/Kruppstr.json?no_lines=6')
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Get.new(uri.request_uri)

def json_to_data(data)
  return {
    :time => data[2].gsub("sofort", "0 min").gsub("min", ""),
    :line => data[0],
    :dest => data[1].gsub("D-", "") # remove "D-"
  }
end

def create_error_data(message)
  return { :t1 => { :dest => message }, :t2 => nil, :t3 => nil, :t4 => nil, :status => "danger" }
end

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  begin
    json = JSON.parse(http.request(request).body)
    unless json["error"].nil?
      send_event('efa', create_error_data("Backend not available right now."))
      return
    end
    pre = json["preformatted"]
    data = {
      :t1 => json_to_data(pre[0]),
      :t2 => json_to_data(pre[1]),
      :t3 => json_to_data(pre[2]),
      :t4 => json_to_data(pre[3]),
      :t5 => json_to_data(pre[4]),
      :t6 => json_to_data(pre[5]),
      :status => "normal"
    }
    if data[:t6][:time] == ""
      data[:status] = "warning"
    end
    send_event('efa', data)
  rescue
    send_event('efa', create_error_data("Couldn't fetch data."))
  end
end
