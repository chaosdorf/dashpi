# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  url = "https://maurudor.de/thumb?#{Time.now}"
  send_event('cat', { image: url })
end
