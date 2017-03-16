# Hadnu

![Codeship Build Status](https://codeship.com/projects/a0e7c3a0-6f75-0134-9a46-3a51310aa3ef/status?branch=master)
[![Code Climate](https://codeclimate.com/github/alanwillms/hadnu-api/badges/gpa.svg)](https://codeclimate.com/github/alanwillms/hadnu-api)
[![Test Coverage](https://codeclimate.com/github/alanwillms/hadnu-ruby/badges/coverage.svg)](https://codeclimate.com/github/alanwillms/hadnu-ruby/coverage)

Hadnu is a library and discussion forum application.

This is the 5th major refactoring of Hadnu.

* Version 1: vanilla HTML
* Version 2: Zend Framework 1
* Version 3: Yii Framework 1.1
* Version 4: Yii Framework 2
* Version 5: Ruby on Rails (back-end) + Vue.js (front-end)

## Requirements

* Ruby 2.4+
* PostgreSQL 9.4+
* ImageMagick

## Deployment

Create a PostgreSQL database.

Copy `.env.example` to `.env` and configure it or add its variables to your
webserver (Nginx, Apache, etc.) and shell environment.

Run `bundle` to install gem dependencies.

Run `bundle exec rails db:migrate` to run database migrations.

## Testing

After installing, run `bundle exec rspec`.
