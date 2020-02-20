class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:friend_id])
    current_user.friends << user
    redirect_back(fallback_location: root_path)
  end

  def update
    user = Friendship.find(params[:id]).creator
    current_user.confirm_friendship(user)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    joining_friendship = Friendship.find(params[:id])
    if current_user == joining_friendship.creator
      current_user.friendships.delete(joining_friendship)
    else
      current_user.inverse_friendships.delete(joining_friendship)
    end
    redirect_back(fallback_location: root_path)
  end
end
