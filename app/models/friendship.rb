class Friendship < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :friend, class_name: 'User'

  validates :creator, uniqueness: { scope: :friend }

  validate :creator_exists, on: :create
  validate :friend_exists, on: :create

  after_update :create_reciprocal_friendship
  after_destroy :remove_reciprocal_friendship

  def creator_exists
    return if User.exists?(email: creator.email)

    errors.add(:creator, 'can only be created by registered user')
  end

  def friend_exists
    return if User.exists?(email: friend.email)

    errors.add(:friend, 'can only be sent to registered user')
  end

  def create_reciprocal_friendship
    Friendship.create(creator_id: friend.id, friend_id: creator.id, accepted: true)
  end

  def remove_reciprocal_friendship
    reciprocal = Friendship
      .where('creator_id = ? AND friend_id = ?', friend.id, creator.id)
      .first
    return if reciprocal.nil?

    reciprocal.destroy
  end
end
