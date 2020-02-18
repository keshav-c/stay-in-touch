# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(name: "keshav", email: "k@m.c", password: "foobar")
(1..100).each do |i|
  User.create(name: "User #{i}", email: "u#{i}@m.c", password: "foobar")
  User.create(name: "User #{i}", email: "u#{i}@m.c", password: "foobar")
  User.create(name: "User #{i}", email: "u#{i}@m.c", password: "foobar")
end