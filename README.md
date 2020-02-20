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

Seed database with:
```
   rails db:seed
```

### Usage

Start server with:

```
    rails server
```

Open `http://localhost:3000/` in your browser.

In order to play around with seeded data:

- Login using credentials: _email_: **u0@m.c**; _password_: **foobar**
- Navigate to **index** (from page header) to see all users, and available actions
- Navigate to **profile** (from page header) to see friends, pending friend requests, and other users from whom you are awaiting response.

### Run tests

```
    rpsec
```

### Deployment

TBA

## Authors

- Keshav Chakravarthy

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check the [issues page](issues/).

## Show your support

Give a ⭐️ if you like this project!

## Acknowledgments

I thank [Microverse](https://github.com/microverseinc) for providing the starter code for this project. 

## 📝 License

TBA

### Notes

Desired SQL for getting requestors from inverse_friendship:

```
SELECT users.* FROM users 
INNER JOIN inverse_friendship ON inverse_friendship.friend_id = user.id
WHERE inverse_frienships.accepted = true/false
AND user.id = ?;
```

code used:

```
User.find(:id).inverse_friendships.includes(:creator).where('accepted = ?', true).map {|u| u.creator}
```

The above code executes three queries

1. Find the user
2. Get all their accepted friendships, which were created by others
3. Get all the creators of those friendship requests

Goal: To reduce this to 1 SQL query.
