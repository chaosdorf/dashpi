if File.directory?('/run/secrets')
    @secrets_path = '/run/secrets'
elsif File.directory?('../secrets')
    @secrets_path = '../secrets'
else
    puts 'Can\'t access secrets.'
    @secrets_path = nil
end

# Load a secret
#
# Usage:
#
#  get_secret('foo') do |value|
#    puts(value)
#  end
#
# or just use it as a function:
#
#  puts(get_secret('foo'))
def get_secret(name)
    return if @secrets_path.nil?
    path = File.join(@secrets_path, name)
    if File.file?(path)
        content = File.read(path).strip
        if block_given?
            yield content
        else
            return content
        end
    end
end
