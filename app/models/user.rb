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
  has_many :inverse_friendships,
           class_name: 'Friendship',
           foreign_key: 'friend_id',
           dependent: :destroy

  def all_friends
    initiated_request = friends.where('accepted = ?', true)
    recieved_request = inverse_friendships
      .includes(:creator)
      .where('accepted = ?', true)
      .map(&:creator)
    (initiated_request + recieved_request).uniq
  end

  def pending_requests_own
    friends.where('accepted = ?', false)
  end

  def request_pending?(user)
    friends.where('accepted = ?', false).exists?(user.id)
  end

  def friendship_with(user)
    friendships.find_by(friend_id: user.id) || inverse_friendships.find_by(creator_id: user.id)
  end

  def pending_requests_others
    inverse_friendships
      .includes(:creator)
      .where('accepted = ?', false)
      .map(&:creator)
  end

  def confirm_friendship(user)
    friendship_request = inverse_friendships.find_by(creator_id: user.id)
    friendship_request.update_attribute(:accepted, true)
  end

  def friend?(user)
    return true if friends.where('accepted = ?', true).exists?(user.id)

    inverse_friendships.where(creator: user, accepted: true).exists?
  end
end
