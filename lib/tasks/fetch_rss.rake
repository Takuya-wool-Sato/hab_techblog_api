# lib/tasks/fetch_rss.rake
require 'feedjira'

namespace :rss do
  desc "Fetch RSS feeds and save to database for each user"
  task fetch: :environment do
    user_feeds = {
      "Harayama Takuya" => { link: 'https://toaru-kaihatsu.com/feed/', avatarSrc: 'https://hab-engineer-api-e2d7db2fc28c.herokuapp.com/avatars/harayama.jpg' },
      "Sato Takuya" => { link: 'https://zenn.dev/wool2405/feed', avatarSrc: 'https://hab-engineer-api-e2d7db2fc28c.herokuapp.com/avatars/s-takuya.jpg' },
      "nakasima" => { link: 'https://zenn.dev/a_nakashima/feed', avatarSrc: 'https://hab-engineer-api-e2d7db2fc28c.herokuapp.com/avatars/nakasima.png' },
      "nagisa" => { link: 'https://qiita.com/nagisa-afadfadf/feed', avatarSrc: 'https://hab-engineer-api-e2d7db2fc28c.herokuapp.com/avatars/nagisa.jpg' },
      "Kayashima Naho" => { link: 'https://qiita.com/naho-0624/feed', avatarSrc: 'https://hab-engineer-api-e2d7db2fc28c.herokuapp.com/avatars/naho.jpg' },
      "Ueno Syoya" => { link: 'https://qiita.com/shoya_u/feed', avatarSrc: 'https://hab-engineer-api-e2d7db2fc28c.herokuapp.com/avatars/ueno.jpeg' },
      "Nagato Shota" => { link: 'https://www.nagato-tech.com/feed.xml', avatarSrc: 'https://hab-engineer-api-e2d7db2fc28c.herokuapp.com/avatars/nagato.jpeg' },
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
