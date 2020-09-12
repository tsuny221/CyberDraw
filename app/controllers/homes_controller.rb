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
         if current_user.over18?
            @users.each do |user|
              # フォローしている人の公開範囲３以外の作品（フォローしている人の作品）
              @following_users_posts.concat(user.posts.where.not(open_range: 3))
              @range12_posts.concat(user.posts.where(open_range: 2))
            end
            # フォローしている人と自分の公開範囲2の作品と公開範囲1の全ての作品(新着、ランキング)
            @posts = @range12_posts + Post.where(open_range: 1) + current_user.posts.where(open_range: 2)
            @new_posts = @posts.sort{|a,b| b[:created_at] <=> a[:created_at]} # 新しい順
            @ranking_posts = @posts.sort {|a,b| b.likes.count <=> a.likes.count}# いいね数順
        #R-18除く
        else
          @users.each do |user|
              @following_users_posts.concat(user.posts.where.not(open_range: 3).where.not(age_limit: 2).where.not(age_limit: 3))
            # フォローしている人の公開範囲2の作品
              @range12_posts.concat(user.posts.where(open_range: 2))
          end
           @posts = @range12_posts + Post.where(open_range: 1) + current_user.posts.where(open_range: 2) - Post.where(age_limit: 2) -  Post.where(age_limit: 3)
          @new_posts = @posts.sort{|a,b| b[:created_at] <=> a[:created_at]} # 新しい順
          @ranking_posts = @posts.sort {|a,b| b.likes.count <=> a.likes.count}# いいね数順
        end

    #サインインしていてフォローしている人がいなくて18際以上の場合
    elsif user_signed_in? && current_user.over18?
          @posts = Post.where(open_range: 1)
          @new_posts = Post.where(open_range: 1).sort{|a,b| b[:created_at] <=> a[:created_at]}
          @ranking_posts = Post.where(open_range: 1).sort {|a,b| b.likes.count <=> a.likes.count}
    #サインインしていない場合や１８歳未満の場合
    else
        @posts = Post.where(open_range: 1, age_limit: 1)
        @new_posts = Post.where(open_range: 1, age_limit: 1).sort{|a,b| b[:created_at] <=> a[:created_at]}
        @ranking_posts = Post.where(open_range: 1, age_limit: 1).sort {|a,b| b.likes.count <=> a.likes.count}
     end
   end
end
