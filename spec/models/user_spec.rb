require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: 'User name',
                     email: 'user@mail.com',
                     password: 'foobar')
    @another_user = User.new(name: 'Another guy',
                             email: 'user@mail.com',
                             password: 'barfoo')
  end

  it 'is valid with a name, email and password' do
    expect(@user).to be_valid
  end

  it 'is invalid without name' do
    @user.name = nil
    @user.valid?
    expect(@user.errors[:name]).to include('can\'t be blank')
  end

  it 'is invalid without an email address' do
    @user.email = nil
    @user.valid?
    expect(@user.errors[:email]).to include('can\'t be blank')
  end

  it 'is invalid with a duplicate email address' do
    @user.save
    @another_user.valid?
    expect(@another_user.errors[:email]).to include('has already been taken')
  end
end
