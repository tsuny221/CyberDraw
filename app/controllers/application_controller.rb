class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :post_index
  before_action :search
  protected

	def configure_permitted_parameters
	devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :image, :birth_date, :gender])
  end

  def after_sign_up_path_for(resource)
    root_path
  end

  def search
      @q = @posts.page(params[:page]).ransack(params[:q])
      @search_posts = @q.result(distinct: true)
  end

  def post_index
      # 18際以上で非公開抜き
     @over_18_posts = Post.where.not(open_range: 3)
      # 18際未満で非公開抜き
     @under_18_posts = Post.where.not(open_range: 3).where.not(age_limit: 2).where.not(age_limit: 3)
    # サインインしていてかつフォローしている人がいる場合の表示
    if user_signed_in? && Relationship.where(follower_id: current_user.id).present?
        @relationships = Relationship.where(follower_id: current_user.id)
        @follow_users = {}
        @relationships.each do |relationship|
          @follow_users = User.where(id: relationship.followed_id)
          @follow_users.merge!(@follow_users)
        end
         if current_user.over18?
              # フォローしている人の作品
              @following_users_posts = @over_18_posts.where(user_id: @follow_users.ids)
              # 公開範囲2で自分がフォローしている人を含めたすべての作品
              @range12_posts = @over_18_posts.where(open_range: 2, user_id: @follow_users.ids).or(@over_18_posts.where(open_range: 1))
        #R-18除く
        else
              # フォローしている人の作品（Rー18抜き）
              @following_users_posts = @under_18_posts.where(user_id: @follow_users.ids)
              # 公開範囲2で自分がフォローしている人を含めた全ての作品（Rー18抜き）
              @range12_posts = @under_18_posts.where(open_range: 2, user_id: @follow_users.ids).or(@under_18_posts.where(open_range: 1))
        end
            # 自分の作品は全ての範囲含める(新着、ランキング順)
            @posts = @range12_posts.or(Post.where(user_id: current_user.id))
            @new_posts = @posts.order(create_at: :desc) # 新しい順
            @ranking_posts = @posts.sort {|a,b| b.likes.count <=> a.likes.count} # いいね数順

    #サインインしている
    elsif user_signed_in?
        # 公開範囲1のものすべて
        if current_user.over18?
          @range1_posts = @over_18_posts.where(open_range: 1)
        #R-18除く
        else
          # 公開範囲1のものすべて (R-18抜き)
          @range1_posts = @under_18_posts.where(open_range: 1)
        end
          # 自分の作品は全ての範囲含める(新着、ランキング順)
          @posts = @range1_posts.or(Post.where(user_id: current_user.id))
          @new_posts = @posts.order(created_at: :desc) # 新しい順
          @ranking_posts = @posts.sort {|a,b| b.likes.count <=> a.likes.count} # いいね数順
    #サインインしていない
    else
        @posts = Post.where(open_range: 1, age_limit: 1)
        @new_posts = @posts.order(created_at: :desc) # 新しい順
        @ranking_posts = @posts.sort {|a,b| b.likes.count <=> a.likes.count} # いいね数順
   end
  end
	# def post_index
  #    # サインインしていてかつフォローしている人がいる場合の表示
  #   if user_signed_in? && current_user.following_user.present?
  #       # フォローしている人
  #       @follow_userss = current_user.following_user
  #       @following_users_posts = []
  #       @range12_posts = []
  #        if current_user.over18?
  #           @follow_userss.each do |user|
  #             # フォローしている人の公開範囲３以外の作品（フォローしている人の作品）
  #             @following_users_posts.concat(user.posts.where.not(open_range: 3))
  #             @range12_posts.concat(user.posts.where(open_range: 2))
  #           end
  #           # フォローしている人と自分の公開範囲2の作品と公開範囲1の全ての作品(新着、ランキング)
  #           @posts = @range12_posts + Post.where(open_range: 1) + current_user.posts.where(open_range: 2)
  #           @new_posts = @posts.sort{|a,b| b[:created_at] <=> a[:created_at]} # 新しい順
  #           @ranking_posts = @posts.sort {|a,b| b.likes.count <=> a.likes.count}# いいね数順
  #       #R-18除く
  #       else
  #         @follow_userss.each do |user|
  #             @following_users_posts.concat(user.posts.where.not(open_range: 3).where.not(age_limit: 2).where.not(age_limit: 3))
  #           # フォローしている人の公開範囲2の作品
  #             @range12_posts.concat(user.posts.where(open_range: 2))
  #         end
  #          @posts = @range12_posts + Post.where(open_range: 1) + current_user.posts.where(open_range: 2) - Post.where(age_limit: 2) -  Post.where(age_limit: 3)
  #         @new_posts = @posts.sort{|a,b| b[:created_at] <=> a[:created_at]} # 新しい順
  #         @ranking_posts = @posts.sort {|a,b| b.likes.count <=> a.likes.count}# いいね数順
  #       end

  #   #サインインしていてフォローしている人がいなくて18際以上の場合
  #   elsif user_signed_in? && current_user.over18?
  #         @posts = Post.where(open_range: 1)
  #         @new_posts = Post.where(open_range: 1).sort{|a,b| b[:created_at] <=> a[:created_at]}
  #         @ranking_posts = Post.where(open_range: 1).sort {|a,b| b.likes.count <=> a.likes.count}
  #   #サインインしていない場合や１８歳未満の場合
  #   else
  #       @posts = Post.where(open_range: 1, age_limit: 1)
  #       @new_posts = Post.where(open_range: 1, age_limit: 1).sort{|a,b| b[:created_at] <=> a[:created_at]}
  #       @ranking_posts = Post.where(open_range: 1, age_limit: 1).sort {|a,b| b.likes.count <=> a.likes.count}
  #    end
  #  end
end
