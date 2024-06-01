class Article < ApplicationRecord
  validates :link, presence: true, uniqueness: { scope: :name }
  validates :name, presence: true
end
