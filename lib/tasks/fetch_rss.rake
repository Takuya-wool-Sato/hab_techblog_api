# lib/tasks/fetch_rss.rake
require 'feedjira'

namespace :rss do
  desc "Fetch RSS feeds and save to database for each user"
  task fetch: :environment do
    user_feeds = {
      "Harayama Takuya" => { link: 'https://toaru-kaihatsu.com/feed/', avatarSrc: 'https://hab-engineer-api-cca27281d192.herokuapp.com/avatars/harayama.jpg' },
      "Sato Takuya" => { link: 'https://wool-blog-astroship.vercel.app/rss.xml', avatarSrc: 'https://hab-engineer-api-cca27281d192.herokuapp.com/avatars/s-takuya.jpg' },
    }


    user_feeds.each do |user_name, feed_data|
      fetch_and_save_feed(feed_data[:link], user_name, feed_data[:avatarSrc])
    end
  end

  def fetch_and_save_feed(link, user_name, avatarSrc)
    feed = Feedjira.parse(HTTParty.get(link).body)

    feed.entries.each do |entry|
      article = Article.find_or_initialize_by(link: entry.url, name: user_name)
      article.title = entry.title
      article.content = entry.content
      article.summary = entry.summary
      article.pubDate = entry.published
      article.avatarSrc = avatarSrc
      article.save!
    end
  end
end
