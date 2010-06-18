require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'base58'

require File.join(File.dirname(__FILE__), 'authorization.rb')
require File.join(File.dirname(__FILE__), 'settings.rb')
require File.join(File.dirname(__FILE__), 'helpers.rb')

require File.join(File.dirname(__FILE__), '..' , 'models', 'models.rb')

post '/' do
  login_required
  
  @short_url = ShortUrl.new(:url => params[:url])
  
  if @short_url.save
    content_type 'application/json'
    @short_url.to_json
  end
end

get %r{^/([a-zA-Z0-9]+)} do |key|
  if @short_url = ShortUrl.find_by_key(key)
    redirect @short_url.url
  else
    raise Sinatra::NotFound
  end
end