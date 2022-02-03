require "sentry-ruby"

def SCHEDULER.on_error(job, exception)
  STDERR.puts "error(#{job.id}): #{exception}"
  STDERR.puts exception.backtrace
  Sentry.capture_exception(exception)
end
