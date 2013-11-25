# This file is used by Rack-based servers to start the application.

pwd = ENV['SEVEN_WWW_PWD']

if pwd
  use Rack::Auth::Basic, 'Restricted Area' do |username, password|
    [username, password] == ['7x7', pwd]
  end
end

require './app'
use Rack::Deflater
run App
