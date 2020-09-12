class HomesController < ApplicationController
  before_action :post_index

  def top
  end

  def ranking
  end


  def new
  end

  private
  def post_index
     # サインインしていてかつフォローしている人がいる場合の表示
    if user_signed_in? && current_user.following_user.present?
        # フォローしている人
        @users = current_user.following_user
        @following_users_posts = []
        @range12_posts = []
        @users.each do |user|
          # フォローしている人の公開範囲３以外の作品（フォローしている人の作品）
          @following_users_posts.concat(user.posts.where.not(open_range: 3))
          # フォローしている人の公開範囲2の作品
          @range12_posts.concat(user.posts.where(open_range: 2))
        end
        # フォローしている人と自分の公開範囲2の作品と公開範囲1の全ての作品(新着、ランキング)
        @posts = (@range12_posts + Post.where(open_range: 1) + current_user.posts.where(open_range: 2))
        @new_posts = @posts.sort{|a,b| b[:created_at] <=> a[:created_at]} # 新しい順
        @ranking_posts = @posts.sort {|a,b| b.likes.count <=> a.likes.count}# いいね数順
    #サインインしていなかったりフォローしている人がいない場合の表示
    else
      @posts = Post.where(open_range: 1)
    end
  end

end
