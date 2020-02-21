require 'rails_helper'

RSpec.feature 'Friendships', type: :feature do
  before do
    @u1 = User.create(name: 'User One', email: 'u1@mail.com', password: 'foobar')
    @u2 = User.create(name: 'User Two', email: 'u2@mail.com', password: 'foobar')
  end

  scenario 'User can send friend request to another user' do
    visit new_user_session_path
    fill_in 'Email', with: @u1.email
    fill_in 'Password', with: @u1.password
    click_button 'Log in'
    click_link 'All users'
    name_id = @u2.name.gsub(' ', '_')
    expect(find("##{name_id}")).to have_button('Friend')
    expect do
      find("##{name_id}").find_button('Friend').click
    end.to change(@u1.pending_requests_own, :count).by(1)
    expect(find("##{name_id}")).to have_button('Unfriend')
  end

  scenario 'User can accept friend requests from another user' do
    @u1.friendships.create(friend: @u2)
    visit new_user_session_path
    fill_in 'Email', with: @u2.email
    fill_in 'Password', with: @u2.password
    click_button 'Log in'
    click_link 'All users'
    name_id = @u1.name.gsub(' ', '_')
    expect(find("##{name_id}")).to have_button('Accept')
    click_link 'Profile'
    click_link 'Pending requests'
    expect(find("##{name_id}")).to have_button('Accept')
    expect(@u1.all_friends).to_not include(@u2)
    expect(@u1.all_friends.count).to eq 0
    expect(@u2.all_friends).to_not include(@u1)
    expect(@u2.all_friends.count).to eq 0
    find("##{name_id}").find_button('Accept').click
    expect(@u1.all_friends).to include(@u2)
    expect(@u1.all_friends.count).to eq 1
    expect(@u2.all_friends).to include(@u1)
    expect(@u2.all_friends.count).to eq 1
    expect(page).to have_content("#{@u1.name} added as friend")
    visit friends_user_path(@u2)
    expect(find("##{name_id}")).to have_button('Unfriend')
  end

  scenario 'User can unfriend current friends' do
    @u1.friendships.create(friend: @u2)
    @u2.confirm_friendship(@u1)
    visit new_user_session_path
    fill_in 'Email', with: @u2.email
    fill_in 'Password', with: @u2.password
    click_button 'Log in'
    click_link 'All users'
    name_id = @u1.name.gsub(' ', '_')
    expect(find("##{name_id}")).to have_button('Unfriend')
    click_link 'Profile'
    find('#friends_page').click
    expect(@u1.all_friends).to include(@u2)
    expect(@u1.all_friends.count).to eq 1
    expect(@u2.all_friends).to include(@u1)
    expect(@u2.all_friends.count).to eq 1
    find("##{name_id}").find_button('Unfriend').click
    expect(@u1.all_friends).to_not include(@u2)
    expect(@u1.all_friends.count).to eq 0
    expect(@u2.all_friends).to_not include(@u1)
    expect(@u2.all_friends.count).to eq 0
    click_link 'All users'
    expect(find("##{name_id}")).to have_button('Friend')
  end

  scenario 'User can undo friend requests' do
    @u1.friendships.create(friend: @u2)
    visit new_user_session_path
    fill_in 'Email', with: @u1.email
    fill_in 'Password', with: @u1.password
    click_button 'Log in'
    click_link 'Profile'
    click_link 'Awaiting response'
    name_id = @u2.name.gsub(' ', '_')
    expect(find("##{name_id}")).to have_button('Unfriend')
    expect(@u1.pending_requests_own).to include(@u2)
    expect(@u1.pending_requests_own.count).to eq 1
    expect(@u2.pending_requests_others).to include(@u1)
    expect(@u2.pending_requests_others.count).to eq 1
    find("##{name_id}").find_button('Unfriend').click
    expect(@u1.pending_requests_own).to_not include(@u2)
    expect(@u1.pending_requests_own.count).to eq 0
    expect(@u2.pending_requests_others).to_not include(@u1)
    expect(@u2.pending_requests_others.count).to eq 0
    click_link 'All users'
    expect(find("##{name_id}")).to have_button('Friend')
  end
end
