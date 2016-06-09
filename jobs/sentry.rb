require "raven"

def SCHEDULER.on_exception(job, exception)
  Raven.capture_exception(exception, :job => job)
end
