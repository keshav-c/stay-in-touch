class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:friend_id])
    current_user.friends << user
    redirect_back(fallback_location: root_path, notice: 'Friendship request sent.')
  end

  def update
    user = Friendship.includes(:creator).find(params[:id]).creator
    current_user.confirm_friendship(user)
    redirect_back(fallback_location: root_path, notice: "#{user.name} added as friend")
  end

  def destroy
    relation = Friendship.find(params[:id])
    relation.destroy
    redirect_back(fallback_location: root_path, notice: 'Unfriend successful')
  end
end
