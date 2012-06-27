#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/base'

require 'haml'

require './lib/sass_handler.rb'
require './lib/coffee_handler.rb'


class Unity < Sinatra::Base
  
  use SassHandler
  use CoffeeHandler
  
  set :public_folder, File.dirname(__FILE__) + '/static'
  set :views, File.dirname(__FILE__) + '/views'
  
  get '/' do
    haml :root
  end

end