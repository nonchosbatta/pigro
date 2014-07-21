#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'sinatra/base'
require 'bcrypt'
require 'data_mapper'
require 'dm-sorting'
require 'dm-sqlite-adapter'
require 'rack/csrf'

class Pigro < Sinatra::Base
  db_path = File.join Dir.pwd, 'db'
  Dir.mkdir db_path unless Dir.exists? db_path
  DataMapper.setup :default, "sqlite3://#{db_path}/app.db"

  set :views, ['app/views']
  configure {
    use Rack::Session::Cookie,
      :path   => '/',
      :secret => 'GwMpn8YBVKfR5pgXnVbSu1Aa7mcEuap0KW8BT'

    use Rack::Csrf,
      :raise => true,
      :field => '_csrf',
      :skip  => [
        'POST:/api/v1/user/login/?',
        'GET:/api/v1/user/csrf_token/?' 
      ]
  }

  %w(controllers helpers models).each do |f|
    Dir.glob("#{Dir.pwd}/app/#{f}/*.rb") { |f| require r.chomp }
  end

  DataMapper.finalize
  DataMapper.auto_upgrade!
end