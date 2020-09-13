class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :post_index, except: [:create, :update, :destroy]
  before_action :search, except: [:create, :update, :destroy]
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
    if user_signed_in? && current_user.following_user.present?
        @follow_users = current_user.following_user
         if current_user.over18?
              # フォローしている人の作品
              @following_users_posts = @over_18_posts.where(user_id: @follow_users)
              # 公開範囲2で自分がフォローしている人を含めたすべての作品
              @range12_posts = @over_18_posts.where(open_range: 2, user_id: @follow_users).or(@over_18_posts.where(open_range: 1))
        #R-18除く
        else
              # フォローしている人の作品（Rー18抜き）
              @following_users_posts = @under_18_posts.where(user_id: @follow_users.ids)
              # 公開範囲2で自分がフォローしている人を含めた全ての作品（Rー18抜き）
              @range12_posts = @under_18_posts.where(open_range: 2, user_id: @follow_users).or(@under_18_posts.where(open_range: 1))
        end
        # 自分の作品は全ての範囲含める(新着、ランキング順)
        @posts = @range12_posts.or(Post.where(user_id: current_user.id))
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
        # 自分の作品は全ての範囲含める
        @posts = @range1_posts.or(Post.where(user_id: current_user.id))
    #サインインしていない
    else
        @posts = Post.where(open_range: 1, age_limit: 1)
    end
    # @postsの並び替え
    @new_posts = @posts.order(created_at: :desc) # 新しい順
    @ranking_posts = @posts.sort {|a,b| b.likes.count <=> a.likes.count} # いいね数順
  end
end
