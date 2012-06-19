set :authorization_realm, "Protected zone"

configure :development do
  DOMAIN = 'http://di-url-shortener.heroku.com'
  set :login, 'admin'
  set :password, 'secret'
end

configure :test do
  DOMAIN = 'http://di-url-shortener.heroku.com'
  set :login, 'admin'
  set :password, 'secret'
end

configure :production do
  DOMAIN = 'http://di-url-shortener.heroku.com'
  set :login, 'admin'
  set :password, 'secret'
end