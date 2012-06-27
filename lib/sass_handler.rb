require 'sass'

class SassHandler < Sinatra::Base
    
  set :views, File.dirname(__FILE__) + '/../sass'

  get '/css/*.css' do
    filename = params[:splat].first
    sass filename.to_sym
  end
    
end