require 'net/http'
require 'json'
require 'twitter'

consumer_key = ''
consumer_secret = ''
oauth_token=''
oauth_token_secret=''

Twitter.configure do |config|
	config.consumer_key = consumer_key
	config.consumer_secret = consumer_secret
	config.oauth_token = oauth_token
	config.oauth_token_secret = oauth_token_secret
end

SCHEDULER.every '1m', :first_in => 0 do |job|
  tweets = []
  for t in Twitter.mentions_timeline(options={count:3})
  	tweets << {name: t.user.name, body: t.text, avatar: t.user.profile_image_url}
  end

  send_event('twitter_mentions', comments: tweets)
end
