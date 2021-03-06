# Easy REST JSON APIs for Sinatra & Active Record


## Getting started

### 1. Setup your Gemfile

```ruby
# Gemfile

gem "sinatra"
gem "sinatra-activerecord" # see https://github.com/janko-m/sinatra-activerecord
gem "sinatra-rest-json"
gem "json"

```

### 2. Setup your Sinatra App

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
### 3. Profit

Now your app automatically has the following routes which returns JSON data from your model (routes are based on your ActiveRecord table name):

- **GET** /products (all)
- **GET** /products/:id (find)

- **POST** /products (create)
- **PUT** /products/:id (update)

- **DELETE** /products/:id (destroy)


*Note for POST/PUT operations the data parameters should be like so: { product: { name: "foo", price: 1 }}


### 4. Authentication

Basic support for authentication is provided like so:

```ruby
# inside your sinatra app

rest_json Product, :authenticate => {
  :all => lambda { true }, # allowed
  :find => lambda { true }, #allowed 
  :create => lambda { false }, #not authorized
  :update => lambda { false }, #not authorized
  :delete => lambda { false }  #not authorized
}
```

You can pass in any ruby object that has a call method which returns a value (e.g. proc or lambda). Naturally you can drop in whatever authentication you'd like

