require "raven"

def SCHEDULER.on_error(job, exception)
  Raven.capture_exception(exception)
end
