# Easy REST JSON APIs for Sinatra & Active Record


Getting started

1. Setup your Gemfile

```ruby
# Gemfile

gem "sinatra"
gem "sinatra-activerecord" # see https://github.com/janko-m/sinatra-activerecord
gem "sinatra-rest-json"
gem "json"

```

2. Setup your Sinatra App

```ruby
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/rest_json'
require 'json'


set :database, {adapter: "sqlite3", database: "foo.sqlite3"}


# Assume some models & database tables exit
# Make sure to provide a to_json method on them
class Product < ActiveRecord::Base
 def to_json
  { :name => name, :price => price }.to_json
 end
end


# Set up your REST routes
rest_json Product
```
3. Profit
Now your app automatically has the following routes:
- GET /products (all)
- GET /products/:id (find)

- POST /products (create)
- PUT /products/:id (update)

- DELETE /people/:id (destroy)


*Note for POST/PUT operations the data parameters should be like so: { product: { name: "foo", price: 1 }}


