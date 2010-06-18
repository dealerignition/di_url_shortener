helpers do
  include Rack::Utils

  def authorize(login, password)
    login == settings.login && password == settings.password
  end
end