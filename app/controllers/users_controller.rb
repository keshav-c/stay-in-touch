class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
    @total_friends = @user.all_friends.count
  end

  def received_friendships
    @received_requests = User.find(params[:id]).pending_requests_others
    render 'show_received_friendships'
  end

  def sent_friendships
    @sent_requests = User.find(params[:id]).pending_requests_own
    render 'show_sent_friendships'
  end

  def friends
    @friends = User.find(params[:id]).all_friends
    render 'show_friends'
  end
end
