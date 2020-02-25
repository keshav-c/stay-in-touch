(1..20).each do |i|
  User.create(name: "User #{i}", email: "u#{i}@m.c", password: "foobar")
end

(2..5).each { |i| User.first.friendships.create(friend: User.find(i)) }
(4..5).each { |i| User.find(i).confirm_friendship(User.first) }
(6..10).each { |i| User.find(i).friendships.create(friend: User.first) }
(9..10).each { |i| User.first.confirm_friendship(User.find(i)) }

hours_ago = 0
(1..20).each do |u|
  4.times do |p|
    post = User.find(u).posts
      .create(content: "This message (numbered #{p + 1}) was created by User #{u}.",
              created_at: rand(300).days.ago)
  end
end