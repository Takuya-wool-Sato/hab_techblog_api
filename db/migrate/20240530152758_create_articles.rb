class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :name
      t.string :avatarSrc
      t.text :content
      t.text :summary
      t.string :link
      t.datetime :pubDate

      t.timestamps
    end
  end
end
