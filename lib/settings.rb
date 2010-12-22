set :authorization_realm, "Protected zone"

configure :development do
  DOMAIN = 'http://di-url-shortener.local'
  set :login, 'admin'
  set :password, 'secret'
end

configure :test do
  DOMAIN = 'http://di-url-shortener.local'
  set :login, 'admin'
  set :password, 'secret'
end

configure :production do
  DOMAIN = 'http://mydea.ly'
  set :login, 'admin'
  set :password, 'secret'
end
