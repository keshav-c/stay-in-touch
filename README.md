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

## Usage

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

### The Lifecycle of a Friendship record

- **Friendship table**

| creator_id  | friend_id | Accepted |
| ------------- | ------------- | ------------- |

- **On `User 1` sending a friend request to `User 2`**

| creator_id  | friend_id | Accepted |
| ------------- | ------------- | ------------- |
| 1  | 2  | False |

- **On `User 2` accepting the friend request sent by `User 1`**

| creator_id  | friend_id | Accepted |
| ------------- | ------------- | ------------- |
| 1  | 2  | True |
| 2  | 1  | True |

- **On either `User 1` or `User 2` unfriending the other**

| creator_id  | friend_id | Accepted |
| ------------- | ------------- | ------------- |

### Deployment

Now deploying to Heroku from feature branch

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

### Future Improvements

- To minimize SQL queries executed on the database to improve performance.
- Notifications