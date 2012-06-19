require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'base58'

require './lib/authorization.rb'
require './lib/settings.rb'
require './lib/helpers.rb'
require './config/db-connection.rb'

require './models/models.rb'

post '/' do
  login_required
  
  @short_url = ShortUrl.new(:url => params[:url])
  
  if @short_url.save
    content_type 'application/json'
    @short_url.to_json
  end
end

get '/stats/:id' do
  @short_url = ShortUrl.find(params[:id])
  
  if @short_url
    content_type 'application/json'
    @short_url.stats.to_json
  else
    raise Sinatra::NotFound
  end
end

get %r{^/([a-zA-Z0-9]+)} do |key|
  if @short_url = ShortUrl.find_by_key(key)
    @short_url.click(request.referrer, request.ip)
    redirect @short_url.url
  else
    raise Sinatra::NotFound
  end
end
