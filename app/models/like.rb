class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user
  #一つの投稿に対して同じユーザーは一度しかいいねできない
  validates_uniqueness_of :post_id, scope: :user_id
end
