# Scaffold for social media app with Ruby on Rails

> This repo includes intial code for social media app with basic styling. Its purpose is to be a starting point for Microverse students.

## Built With

- Ruby v2.7.0
- Ruby on Rails v5.2.4

## Live Demo

TBA


## Getting Started

To get a local copy up and running follow these simple example steps.

### Prerequisites

Ruby: 2.6.3
Rails: 5.2.3
Postgres: >=9.5

### Setup

Instal gems with:

```
bundle install
```

Setup database with:

```
   rails db:create
   rails db:migrate
```

### Console Testing

101 users are setup in seeds

```
users = User.all
u1 = users[0]

# u1 initiates friendship requests for users with ids 5 to 10: Correct
(5..10).each { |i| u1.friendships.create(friend: User.find(i)) }

# users with ids 11 to 15 initiate friend request to u1
(11..15).each { |i| User.find(i).friendships.create(friend: u1) }

u1.all_friends # -> []

u1.pending_requests_own # returns users with pending requests from u1

u1.pending_requests_others # WRONG: returns friendship requests rather than users

# confirm a subset of friendship requests
(9..10).each { |i| User.find(i).confirm_friendship(u1) }
(12..15).each { |i| u1.confirm_friendship(User.find(i)) }

```

### Usage

Start server with:

```
    rails server
```

Open `http://localhost:3000/` in your browser.

### Run tests

```
    rpsec --format documentation
```

> Tests will be added by Microverse students. There are no tests for initial features in order to make sure that students write all tests from scratch.

### Deployment

TBA

## Authors

TBA

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check the [issues page](issues/).

## Show your support

Give a ⭐️ if you like this project!

## Acknowledgments

TBA

## 📝 License

TBA

