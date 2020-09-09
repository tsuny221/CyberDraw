class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :screen_user, only: [:edit, :update, :destroy]
  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    # スペースを入れることでタグを保存可能
    tag_list = params[:post][:name].split(nil)
    if @post.save
      # タグを複数保存する多対多を組み、メソッドをpostモデルに追加することでできる
      @post.save_tag(tag_list)
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    # 投稿に画像が存在して、かつ、選択した画像がある場合その画像を削除
    if @post.images.attached? && !params[:post][:image_ids].nil?
      params[:post][:image_ids].each do |image_id|
        image = @post.images.find(image_id)
        image.purge
      end
    end
    if @post.update(post_params)
      redirect_to post_path(@post.id)
    else
      render :edit
    end
  end
  def index
    @posts = Post.where(open_range: 1)

  end
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to root_path
  end

  private
  def post_params
    params.require(:post).permit(:title, :caption, :age_limit, :open_range, images: [])
  end

  def screen_user
      @post = Post.find(params[:id])
      if @post.user.id != current_user.id
        redirect_to root_path
      end
    end
end
