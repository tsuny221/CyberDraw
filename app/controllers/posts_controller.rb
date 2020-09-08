class PostsController < ApplicationController

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

  end
  def update

  end
  def index
    @posts = Post.where(open_range: 1)

  end
  def destroy

  end

  private
  def post_params
    params.require(:post).permit(:title, :caption, :age_limit, :open_range, images: [])
  end
end
