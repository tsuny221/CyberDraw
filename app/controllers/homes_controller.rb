class HomesController < ApplicationController
  def top
    @posts = Post.where(open_range: 1)
  end
end
