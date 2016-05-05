
SCHEDULER.in "5s" do |job|
  #reload the dashboard on restart of Dashing
  send_event("reload", {})
end
