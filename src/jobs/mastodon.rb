require 'mastodon'
require 'nokogiri'

count_toots = 10
toots = Array.new(count_toots).fill({ id: 0, name: '', nickname: '', body: '', avatar: '', time: Time.new })

def add_toot(toots, toot)
  toots[0] = { id: toot.id, name: toot.account.display_name, nickname: toot.account.acct, body: Nokogiri::HTML(toot.content).text, avatar: toot.account.avatar, time: toot.created_at }
  toots.rotate!
end

rest_client = Mastodon::REST::Client.new(base_url: 'https://mastodon.social')

SCHEDULER.every '1m', allow_overlapping: false, first_in: 0 do |job|
  rest_client.hashtag_timeline('dorfleaks').each do |toot|
    add_toot(toots, toot)
  end
  send_event 'mastodon', comments: toots
end
