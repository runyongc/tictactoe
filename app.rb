require 'sinatra'
require 'json'
require 'pg'
require 'omniauth'
require 'omniauth-facebook'
require 'omniauth-google-oauth2'
require_relative 'tictactoe.rb'


configure do
  use Rack::Session::Pool
  set :inline_templates, true
end

use OmniAuth::Builder do
  provider :facebook, '1283085635154950', 'a5249f2819d8857a531a73ed31a7c29e'
  provider :google_oauth2, '763470417567-ki9uikdee72fu5ab53ol611n2dm2pmmh.apps.googleusercontent.com', 'azKGBJvvJzEpgJ8XsngZkCTP'
  #provider :att, 'client_id', 'client_secret'
end

helpers do
  def database_query
    db = PG::Connection.new(ENV['DATABASE_URL'])
    session[:highscore] = db.exec('SELECT * FROM tictac_highscores;').to_a
  end

  def update_highscores(column)
    db = PG::Connection.new(ENV['DATABASE_URL'])
    columnname = column
    db.exec("UPDATE tictac_highscores SET #{columnname} = #{columnname} + 1")
  end

end

get '/' do
  erb :index
end

get '/auth/:provider/callback' do
  session[:authenticated] = true
  session[:profile_picture] = request.env['omniauth.auth']['info']['image']
  session[:name] = request.env['omniauth.auth']['info']['name']
  redirect '/newgame'
end

get '/newgame' do
  erb :newgame
end

post '/startgame' do
  @currentGame = TicTacToe.new(params[:difficulty], params[:gridsize])
  session[:game] = @currentGame
  redirect '/tictactoe'
end

get '/tictactoe' do
  if session[:game].gridsize == "3"
    erb :tictactoe
  elsif session[:game].gridsize == "4"
    erb :tictactoe4x4
  end
end

get '/playermoved' do
  session[:game].playGame(params[:tttmove])
  p "#{session[:game].currentBoard}"
  if session[:game].gridsize == "3"
    erb :tictactoe
  elsif session[:game].gridsize == "4"
    erb :tictactoe4x4
  else
    erb :tictactoe

  end
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
