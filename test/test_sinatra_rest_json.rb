ENV['RACK_ENV'] = 'test'

require 'rack/test'
require "minitest/autorun"

require 'sinatra/base'
require 'sinatra/rest-json'
require 'json'

require File.join(File.dirname(__FILE__), "helper")

class TestApp < Sinatra::Base
  register Sinatra::REST
  rest_json FooModel
end


describe "app" do 
  include Rack::Test::Methods

  def app
    TestApp
  end

  before do
    FooModel.destroy_all
  end

  describe "GET /" do
    it "should be empty when no models" do
      get "/foo_models"
      assert_equal last_response.body, "[]"
    end

    it "should not be empty when models present" do
      FooModel.create(:name => "foo1")

      get "/foo_models"
      assert_equal last_response.body, "[{\"id\":1,\"name\":\"foo1\"}]"
    end
  end


  describe "GET /foo_models/:id" do
    it "should give error when no models" do
      get "/foo_models/1"
      assert_equal last_response.body, "{\"errors\":[\"record doesn\'t exist\"]}"
    end

    it "should find model when it exists" do 
      model = FooModel.create(:name => "foo1")
      get "/foo_models/#{model.id}"
      assert_equal last_response.body, "{\"id\":#{model.id},\"name\":\"foo1\"}" 
    end
  end

  describe "POST /foo_models" do
    it "should create a new model" do
      assert_equal FooModel.all.size, 0 
      post "/foo_models", { :foo_model => { :name => "foo1" } }
      assert_equal last_response.body, "{\"id\":1,\"name\":\"foo1\"}"
      assert_equal FooModel.all.size, 1
    end

    it "should send back errors when validation fails" do
      post "/foo_models", { :foo_model => { :name => nil } }
      assert_equal last_response.body, "{\"errors\":[{\"name\":\"cant be blank\"}]}"
    end
  end


  describe "PUT /foo_models/:id" do
    it "should give error when not found" do
      put "/foo_models/1", { :name => "boo" }
      assert_equal last_response.body, "{\"errors\":[\"record doesn\'t exist\"]}"
    end

    it "should update model when it exists" do
      FooModel.create(:name => "foo1")
      put "/foo_models/1", { :foo_model => { :name => "boo" } }
      assert_equal last_response.body, "{\"id\":1,\"name\":\"boo\"}"
    end
  end


  describe "DELETE /foo_models/:id" do
    it "should give error when not found" do
      delete "/foo_models/1"
      assert_equal last_response.body, "{\"errors\":[\"record doesn\'t exist\"]}"
    end

    it "should respond with delted object" do 
      FooModel.create(:name => "foo1")
      delete "/foo_models/1"
      assert_equal last_response.body, "{\"id\":1,\"name\":\"foo1\"}"
    end

    it "should actually delete model" do 
      FooModel.create(:name => "foo1")
      assert_equal FooModel.all.size, 1 

      delete "/foo_models/1"
      assert_equal FooModel.all.size, 0 
    end
  end

end
