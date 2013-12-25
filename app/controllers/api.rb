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
  # get the titles of all shows
  get '/api/shows/all.:format' do |format|
    result = Show.all
    export result, { as: format, only: :name }
  end

  # get the title of the show searching it with the given keyword
  get '/api/shows/search/:keyword.:format' do |keyword, format|
    result = Show.find_shows keyword
    export result, { as: format, only: :name }
  end

  # get given show infos
  get '/api/shows/get/:show.:format' do |show, format|
    result = Show.get_show show
    export result, { as: format }
  end

  # get all the episode of the given show
  get '/api/shows/get/:show/episodes/list.:format' do |show, format|
    result = Episode.get_episodes show
    export result, { as: format, only: :episode }
  end

  # get episode infos of the given show
  get '/api/shows/get/:show/episodes/get/:episode.:format' do |show, episode, format|
    result = Episode.get_episode show, episode.to_i
    export result, { as: format }
  end
end