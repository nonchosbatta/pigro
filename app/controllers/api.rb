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
    @callback = params.delete 'callback'
  end

  get '/api/shows/all' do
    result = Show.all
    export result, @callback, only: :name
  end

  get '/api/shows/search/:keyword' do |keyword|
    result = Show.find_shows keyword
    export result, @callback, only: :name
  end

  get '/api/shows/get/:show' do |show|
    result = Show.get_show show
    export result, @callback
  end

  get '/api/shows/get/:show/episodes/list' do |show|
    result = Episode.get_episodes show
    export result, @callback, only: :episode
  end

  get '/api/shows/get/:show/episodes/get/:episode' do |show, episode|
    result = Episode.get_episode show, episode.to_i
    export result, @callback
  end
end