class Post < ApplicationRecord
  has_many_attached :images
  belongs_to :user, optional: true
  has_many :tag_posts, dependent: :destroy
  has_many :tags, through: :tag_posts
  enum age_limit: { 全年齢: 1, "R-18": 2, "R-18G": 3 }
  enum open_range: { 全体に公開: 1, フォロワーに公開: 2, 非公開: 3 }
  validates :title, presence: true
  validates :caption, presence: true
  validates :images, presence: true
  # タグを複数保存するメソッド
  def save_tag(tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags
    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
    end
  end
end
