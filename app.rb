
require 'sinatra'
require 'json'
require 'omniauth'
require 'omniauth-facebook'
require 'omniauth-google-oauth2'
require_relative 'tictactoe.rb'

# set :ssl_certificate, "cert.crt"
# set :ssl_key, "pkey.pem"
# set :port, 9494


  configure do
    use Rack::Session::Pool
    set :inline_templates, true
  end
  use OmniAuth::Builder do
    provider :facebook, '1283085635154950','a5249f2819d8857a531a73ed31a7c29e'
    provider :google_oauth2, '763470417567-ki9uikdee72fu5ab53ol611n2dm2pmmh.apps.googleusercontent.com', 'azKGBJvvJzEpgJ8XsngZkCTP'
    #provider :att, 'client_id', 'client_secret'
  end

  
# helpers do
#     def displayPicture
#       picture = request.env['omniauth.auth']['info']['image']
#     end
#   end
  
  get '/' do
    erb :index
  end
  
  get '/auth/:provider/callback' do
    session[:profile_picture] = request.env['omniauth.auth']['info']['image']
    session[:name] = request.env['omniauth.auth']['info']['name']
    redirect '/newgame'
  end
  
  get '/newgame' do
    erb :newgame
  end

  post '/startgame' do
    currentGame = TicTacToe.new(params[:difficulty])
    session[:game] = currentGame
    redirect '/tictactoe'
  end

  get '/tictactoe' do
    erb :tictactoe
  end

  get '/playermoved' do
    session[:game].playGame(params[:tttmove])
    erb :tictactoe
  end

  get '/auth/failure' do
    erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>"
  end
  
  get '/auth/:provider/deauthorized' do
    erb "#{params[:provider]} has deauthorized this app."
  end
  
  get '/protected' do
    throw(:halt, [401, "Not authorized\n"]) unless session[:authenticated]
    erb "<a href='/logout'>Logout</a>"
  end
  
  get '/logout' do
    session[:authenticated] = false
    redirect '/'
  end
  
  get '/privacy' do
    erb :privacy
  end

  get '/tos' do
    erb :tos
  end

  get '/testing' do
    erb :privacy
  end