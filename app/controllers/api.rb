#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

class Pigro
  before /\/api\// do
    cross_origin
  end

  get '/api/shows/all' do
    result = Show.all
    export result, only: :name
  end

  get '/api/shows/search/:keyword' do |keyword|
    result = Show.find_shows keyword
    export result, only: :name
  end

  get '/api/shows/get/:show' do |show|
    result = Show.get_show show
    export result
  end

  get '/api/shows/get/:show/episodes/all' do |show|
    result = Episode.get_episodes show
    export result
  end
end