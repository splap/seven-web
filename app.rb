require "bundler"
Bundler.require(:default)
require "net/smtp"

require 'sinatra/base'
require 'sinatra/assetpack'

class App < Sinatra::Base
  set :root, './'
  register Sinatra::AssetPack

  assets do
    serve '/js',  :from => 'app/js'
    serve '/css', :from => 'app/css'
    serve '/images', :from => 'app/images'

    js  :main, %w(/js/jquery.js /js/bootstrap.js /js/seven.js)
    css :main, %w(/css/bootstrap.css /css/seven.css)
    
    js_compression  :uglify    # :jsmin | :yui | :closure | :uglify
    css_compression :simple   # :simple | :sass | :yui | :sqwish

    asset_hosts ['//d25m74kwqry4gf.cloudfront.net'] if App.production?

  end

  # Pretty-print HTML in all environments.  A bit slower, but we want the source to look nice.
  Slim::Engine.set_default_options :pretty => true, :sort_attrs => false

  set :views, settings.root + '/templates'

  get "/" do
    slim :seven
  end
  get "/seven.html" do
    slim :seven
  end
  
  get "/work/:name" do |name|
    slim :"work/#{name}", :layout => false
  end

  get '/foo' do
    slim :foo
  end

  get '/bah' do
    slim :bah, :layout => false
  end

  get "/heartbeat.html" do
    "OK"
  end

  post "/mailer" do

    to = "info@7x7labs.com"

    email   = params[:email].empty?   ? "?"            : params[:email]
    name    = params[:name].empty?    ? "Unknown"      : params[:name]
    message = params[:message].empty? ? "(no message)" : params[:message]

    body = [
      "From: 7x7labs.com",
      "To: <#{to}>",
      "Subject: sales lead from 7x7labs.com",
      "",
      "[contact info: #{name} <#{email}>]",
      "",
      message
    ].join("\r\n")

    host = "smtp.gmail.com"
    user = "hal@7x7labs.com"
    pass = ENV["SMTP_PWD"]
    smtp = Net::SMTP.new(host, 587)
    smtp.enable_starttls

    smtp.start(host, user, pass, :login) do
      smtp.send_message(body, user, to)
    end

  end
end

require './app/rb/patch.rb'
