require File.join(File.dirname(__FILE__), 'lib', 'di_url_shortener.rb')

set :env, :production
disable :run, :reload

run Sinatra::Application