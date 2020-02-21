class Friendship < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :friend, class_name: 'User'

  validates :creator, uniqueness: { scope: :friend }

  validate :creator_exists, on: :create
  validate :friend_exists, on: :create

  def creator_exists
    return if User.exists?(email: creator.email)

    errors.add(:creator, 'can only be created by registered user')
  end

  def friend_exists
    return if User.exists?(email: friend.email)

    errors.add(:friend, 'can only be sent to registered user')
  end
end
