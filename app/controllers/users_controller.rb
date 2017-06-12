class UsersController < ApplicationController

before_action :sign_in, only: [:index, :edit, :update]
before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
before_action :correct_user, only: [:edit, :update]
before_action :admin_user, only: :destroy

  def new
  	@user = User.new
  end

  def user_params
  	params.require(:user).permit(:name, :email)
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      sign_in @user
      ##sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
     	# Handle a successful save.
  	else
    	render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success]= "Profile Updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success]="User destroyed."
    redirected_to users_path
  end

  #def sign_in(user)
  #  cookies.permanent[:remember_token] = user.remember_token
  #  self.current_user = user
  #end

  private

  def user_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  #BEFORE_ACTIONS

  def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in." unless signed_in?
      end
  end

  def correct_user
     @user = User.find(params[:id])
     redirect_to(root_path) unless current_user?(@user)
  end
end