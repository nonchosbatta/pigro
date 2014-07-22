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
  DataMapper.setup :default, "sqlite3://#{db_path}/spec.db"

  configure {
    use Rack::Session::Cookie,
      :path   => '/',
      :secret => '9CvfMYhkIaIquRn3jG7BA74OwJU8LlP3WHauz'

    use Rack::Csrf,
      :raise => true,
      :field => '_csrf'
  }

  %w(helpers models controllers).each do |f|
    Dir.glob("#{Dir.pwd}/app/#{f}/*.rb") { |r| require r.chomp }
  end

  DataMapper.finalize
  DataMapper.auto_upgrade!
end
