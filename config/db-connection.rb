config_file = File.join(File.dirname(__FILE__), 'database.yml')
if File.exists?(config_file)
  require 'yaml'
  db = YAML.load_file(config_file)[ENV['RACK_ENV']]
  url = "#{db['adapter']}://#{db['username']}:#{db['password']}@#{db['host']}/#{db['database']}"
else
  url = ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/../di_url_shortener/db/di_url_shortener_#{ENV['RACK_ENV']}.sqlite3"
end

#puts "using db url: #{url}"
  set :database, url