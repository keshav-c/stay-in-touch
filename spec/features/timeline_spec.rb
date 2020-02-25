require 'rails_helper'

RSpec.feature 'Timelines', type: :feature do
  before do
    @u1 = User.create(name: 'User One', email: 'u1@mail.com', password: 'foobar')
    @u2 = User.create(name: 'User Two', email: 'u2@mail.com', password: 'foobar')
    @u3 = User.create(name: 'User Three', email: 'u3@mail.com', password: 'foobar')
    @u1.friendships.create(friend: @u2)
    @u2.confirm_friendship(@u1)
    @posts = []
    2.times do |p|
      @posts << @u1.posts.create(content: "Message number #{p + 1} by #{@u1.name}",
                                 created_at: (p * 3 + 1).hours.ago)
      @posts << @u2.posts.create(content: "Message number #{p + 1} by #{@u2.name}",
                                 created_at: (p * 3 + 2).hours.ago)
      @posts << @u3.posts.create(content: "Message number #{p + 1} by #{@u3.name}",
                                 created_at: (p * 3 + 3).hours.ago)
    end
  end

  scenario 'current user\'s timeline has only their posts and their friends\' posts' do
    visit new_user_session_path
    fill_in 'Email', with: @u1.email
    fill_in 'Password', with: @u1.password
    click_button 'Log in'
    click_link 'Timeline'
    @u1.posts.each do |post|
      expect(page).to have_selector("#post-#{post.id}")
    end
    @u2.posts.each do |post|
      expect(page).to have_selector("#post-#{post.id}")
    end
    @u3.posts.each do |post|
      expect(page).to_not have_selector("#post-#{post.id}")
    end
    click_link 'Sign out'
    fill_in 'Email', with: @u2.email
    fill_in 'Password', with: @u2.password
    click_button 'Log in'
    click_link 'Timeline'
    @u1.posts.each do |post|
      expect(page).to have_selector("#post-#{post.id}")
    end
    @u2.posts.each do |post|
      expect(page).to have_selector("#post-#{post.id}")
    end
    @u3.posts.each do |post|
      expect(page).to_not have_selector("#post-#{post.id}")
    end
    click_link 'Sign out'
    fill_in 'Email', with: @u3.email
    fill_in 'Password', with: @u3.password
    click_button 'Log in'
    click_link 'Timeline'
    @u1.posts.each do |post|
      expect(page).to_not have_selector("#post-#{post.id}")
    end
    @u2.posts.each do |post|
      expect(page).to_not have_selector("#post-#{post.id}")
    end
    @u3.posts.each do |post|
      expect(page).to have_selector("#post-#{post.id}")
    end
  end

  scenario 'timeline posts are in descending order of creation (oldest first)' do
    visit new_user_session_path
    fill_in 'Email', with: @u1.email
    fill_in 'Password', with: @u1.password
    click_button 'Log in'
    click_link 'Timeline'
    expect(page.find('li:nth-child(1)')).to have_selector("#post-#{@posts[0].id}")
    expect(page.find('li:nth-child(2)')).to have_selector("#post-#{@posts[1].id}")
    expect(page.find('li:nth-child(3)')).to have_selector("#post-#{@posts[3].id}")
    expect(page.find('li:nth-child(4)')).to have_selector("#post-#{@posts[4].id}")
    click_link 'Sign out'
    fill_in 'Email', with: @u3.email
    fill_in 'Password', with: @u3.password
    click_button 'Log in'
    click_link 'Timeline'
    expect(page.find('li:nth-child(1)')).to have_selector("#post-#{@posts[2].id}")
    expect(page.find('li:nth-child(2)')).to have_selector("#post-#{@posts[5].id}")
    click_link 'Sign out'
    fill_in 'Email', with: @u2.email
    fill_in 'Password', with: @u1.password
    click_button 'Log in'
    click_link 'Timeline'
    expect(page.find('li:nth-child(1)')).to have_selector("#post-#{@posts[0].id}")
    expect(page.find('li:nth-child(2)')).to have_selector("#post-#{@posts[1].id}")
    expect(page.find('li:nth-child(3)')).to have_selector("#post-#{@posts[3].id}")
    expect(page.find('li:nth-child(4)')).to have_selector("#post-#{@posts[4].id}")
  end
end
