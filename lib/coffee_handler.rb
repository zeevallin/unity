require 'coffee-script'

class CoffeeHandler < Sinatra::Base
  
  set :views, File.dirname(__FILE__) + '/../coffee'

  get "/js/*.js" do
    filename = params[:splat].first
    coffee filename.to_sym
  end
  
end