# ToDo Web App

> The main goal of this exercise is to develop a web application with **Ruby on Rails** in which we are going to implement a web system for managing a ToDo Web Application similar to Todoist.

## Built With

- Ruby 2.7.0
- Rails 6.0.2.1
- Bootstrap 4

## Usage

Install missing gems:

```shell
bundle install
```

Run the migration command:
```
rails db:migrate
```

Populate the database:

```
rails db:seed
```

Start rails server. It will be listening on localhost:3000

```shell
rails server
```

## Basic access control
The app have a User Management module which permits users to access the system by authenticating themselves and determining roles: __administrator__ and __user__.

For creating the first admin user before the application can be used, we have seeded an admin user in database:

```
email: admin@todoapp.com
password: Administrator.
```

## Testing with rspec

#### Installing geckodriver

1. Download the latest version of the driver

```bash
wget https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz
```

2. Extract the file:

```bash
tar -xvzf geckodriver*
```

3. Make it executable

```bash
chmod +x geckodriver
```

4. Move to /user/bin

```bash
mv geckodriver /usr/bin/
```

## Authors

[Sergio González](https://github.com/SergioGonzalezVelazquez)
[Antonio Rubio](https://github.com/4Paloms)
[Victor Ávila](https://github.com/victoravila117)
[Victor Mora](https://github.com/VictorMora97)
