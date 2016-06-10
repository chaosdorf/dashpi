require "raven"

def SCHEDULER.on_exception(job, exception)
  Raven.capture_exception(exception, tags: { job: job })
end
