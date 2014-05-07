require 'sinatra/base'
require 'json'

module Sinatra
  module REST
    NOT_FOUND = { :errors => ["record doesn't exist"] }.to_json
    MODEL_REGEX = /([A-Z0-9]{1}[a-z0-9]+)/

    def rest_json(model_class, opts = {})
      model_name = model_class.name.scan(MODEL_REGEX).join("_").downcase
      route_name = model_class.table_name

      # all
      get "/#{route_name}" do
        content_type :json
        "["  + model_class.all.collect { |m| m.to_json }.join(",") + "]"
      end

      # find
      get "/#{route_name}/:id" do
        content_type :json
        model = model_class.find(params[:id].to_i)

        if model.nil?
         NOT_FOUND 
        else
          model.to_json
        end
      end

      # create
      post "/#{route_name}" do
        content_type :json

        model = model_class.new(params[model_name])

        if model.save
          model.to_json
        else
          { :errors => model.errors }.to_json
        end
      end

      # update
      put "/#{route_name}/:id" do
        content_type :json

        model = model_class.find(params[:id].to_i)

        if model.nil?
          NOT_FOUND
        else
          if model.update_attributes(params[model_name])
            model.to_json
          else
            { :errors => model.errors }.to_json
          end
        end
      end

      # delete
      delete "/#{route_name}/:id" do
        content_type :json

        model = model_class.find(params[:id].to_i)

        if model.nil?
          NOT_FOUND
        else
          model.destroy.to_json
        end
      end
    end

  end

  register REST
end
