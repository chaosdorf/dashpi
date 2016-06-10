require "raven"

def SCHEDULER.on_exception(exception)
  Raven.capture_exception(exception)
end
