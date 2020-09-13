class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :screen_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @user_posts = @new_posts.where(user_id: current_user)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def follower

  end

  def followed

  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :introduction, :birth_date, :gender, :image)
  end

  def screen_user
      unless params[:id].to_i == current_user.id
        redirect_to user_path(current_user)
      end
    end

end
