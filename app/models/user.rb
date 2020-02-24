class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships,
           inverse_of: :creator,
           foreign_key: 'creator_id',
           dependent: :destroy
  has_many :friends, through: :friendships

  def all_friends
    friends.where('accepted = ?', true)
  end

  def pending_requests_own
    friends.where('accepted = ?', false)
  end

  def request_pending?(user)
    friends.where('accepted = ?', false).exists?(user.id)
  end

  def friendship_with(user)
    friendships.find_by(friend_id: user.id) || user.friendships.find_by(friend_id: id)
  end

  def pending_requests_others
    Friendship
      .includes(:creator)
      .where('friend_id = ? AND accepted = ?', id, false)
      .map(&:creator)
  end

  def confirm_friendship(user)
    friendship_request = user.friendships.find_by(friend_id: id)
    friendship_request&.update_attribute(:accepted, true)
  end

  def friend?(user)
    friends.where('accepted = ?', true).exists?(user.id)
  end
end
