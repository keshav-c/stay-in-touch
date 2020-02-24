# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
(1..10).each do |i|
  User.create(name: "User #{i}", email: "u#{i}@m.c", password: "foobar")
end
(2..5).each { |i| User.first.friendships.create(friend: User.find(i)) }
(4..5).each { |i| User.find(i).confirm_friendship(User.first) }
(6..10).each { |i| User.find(i).friendships.create(friend: User.first) }
(9..10).each { |i| User.first.confirm_friendship(User.find(i)) }