class RelationshipsController < ApplicationController
  def create
    @user = params[:user_id].to_i
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  def destroy
    @user = params[:user_id].to_i
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  def follower
    user = User.find(params[:user_id])
    @users = user.following_user
  end

  def followed
    user = User.find(params[:user_id])
    @users = user.follower_user
  end
end
