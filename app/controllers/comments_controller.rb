class CommentsController < ApplicationController
  def create
      @post = Post.find(params[:post_id])
      #投稿に紐づいたコメントを作成
      @comment = @post.comments.new(comment_params)
      @comment.user_id = current_user.id
      @comment.save
end

    def destroy
      @comment = Comment.find(params[:id])
      #これ忘れると削除した後の読み込みができない
      @post = @comment.post
      if @comment.user != current_user
        redirect_to request.referer
      end
      @comment.destroy
    end

    private
    def comment_params
      params.require(:comment).permit(:content, :post_id, :user_id)
    end
end
