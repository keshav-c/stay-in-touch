require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before do
    @user1 = User.new(name: 'u1', email: 'u1@m.c', password: 'foobar')
    @user2 = User.new(name: 'u2', email: 'u2@m.c', password: 'foobar')
  end

  it "is valid with existing creator and friend" do
    @user1.save
    @user2.save
    f = @user1.friendships.build(friend: @user2)
    expect(f).to be_valid
  end

  it "is invalid with no creator" do
    @user2.save
    f = @user1.friendships.build(friend: @user2)
    f.valid?
    expect(f.errors[:creator]).to include('can only be created by registered user')
  end

  it "is invalid with no friend" do
    @user1.save
    f = @user1.friendships.build(friend: @user2)
    f.valid?
    expect(f.errors[:friend]).to include('can only be sent to registered user')
  end

  it "is invalid if friendship exists" do
    @user1.save
    @user2.save
    f1 = @user1.friendships.create(friend: @user2)
    f2 = @user1.friendships.build(friend: @user2)
    expect(f2).to_not be_valid
  end
end
