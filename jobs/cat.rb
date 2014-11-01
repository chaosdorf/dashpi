# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '10s', :first_in => 0 do |job|
  send_event('cat', { image: "https://randomcat.marudor.de/?#{Time.now}" })
end
