require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before do
    @u1 = User.new(name: 'u1', email: 'u1@m.c', password: 'foobar')
    @u2 = User.new(name: 'u2', email: 'u2@m.c', password: 'foobar')
  end

  it 'is valid with existing creator and friend' do
    @u1.save
    @u2.save
    f = @u1.friendships.build(friend: @u2)
    expect(f).to be_valid
  end

  it 'is invalid with no creator' do
    @u2.save
    f = @u1.friendships.build(friend: @u2)
    f.valid?
    expect(f.errors[:creator]).to include('can only be created by registered user')
  end

  it 'is invalid with no friend' do
    @u1.save
    f = @u1.friendships.build(friend: @u2)
    f.valid?
    expect(f.errors[:friend]).to include('can only be sent to registered user')
  end

  it 'is invalid if friendship exists' do
    @u1.save
    @u2.save
    @u1.friendships.create(friend: @u2)
    f = @u1.friendships.build(friend: @u2)
    expect(f).to_not be_valid
  end

  it 'creates a mutual friendship on accepting request' do
    @u1.save
    @u2.save
    @u1.friends << @u2
    expect(Friendship.where(creator_id: @u1.id, friend_id: @u2.id, accepted: false)).to exist
    expect(Friendship.where(creator_id: @u2.id, friend_id: @u1.id)).to_not exist
    @u2.confirm_friendship(@u1)
    expect(Friendship.where(creator_id: @u1.id, friend_id: @u2.id, accepted: true)).to exist
    expect(Friendship.where(creator_id: @u2.id, friend_id: @u1.id, accepted: true)).to exist
  end

  it 'destroys both mutual friendship records on unfriend' do
    @u1.save
    @u2.save
    @u1.friends << @u2
    @u2.confirm_friendship(@u1)
    expect(Friendship.where(creator_id: @u1.id, friend_id: @u2.id, accepted: true)).to exist
    expect(Friendship.where(creator_id: @u2.id, friend_id: @u1.id, accepted: true)).to exist
    f = @u2.friendship_with(@u1)
    f.destroy
    expect(Friendship.where(creator_id: @u1.id, friend_id: @u2.id)).to_not exist
    expect(Friendship.where(creator_id: @u2.id, friend_id: @u1.id)).to_not exist
  end
end
