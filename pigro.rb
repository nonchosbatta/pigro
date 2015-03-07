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
require 'dm-postgres-adapter'
require 'rack/csrf'

class Pigro < Sinatra::Base
  data = {
    user: 'user',
    pass: 'pass',
    host: 'localhost',
    db:   'pigro'
  }

  DataMapper.setup :default, "postgres://#{data[:user]}:#{data[:pass]}@#{data[:host]}/#{data[:db]}"

  set :views, ['app/views']
  configure {
    use Rack::Session::Cookie,
      :path   => '/',
      :secret => 'GwMpn8YBVKmR5pgXnjbSu1Aa7mc9uap0oW8BT'

    use Rack::Csrf,
      :raise => true,
      :field => '_csrf',
      :skip  => [
        'POST:/api/v1/user/login/?',
        'GET:/api/v1/user/csrf_token/?' 
      ]
  }

  %w(controllers helpers models).each do |f|
    Dir.glob("#{Dir.pwd}/app/#{f}/*.rb") { |r| require r.chomp }
  end

  DataMapper.finalize
  DataMapper.auto_upgrade!
end

