require "raven"

def SCHEDULER.on_error(job, exception)
  STDERR.puts "error(#{job.id}): #{exception}"
  Raven.capture_exception(exception)
end
