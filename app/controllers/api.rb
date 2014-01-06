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

  # return all the shows with the given status and fansub
  get '/api/v1/shows/all/:status/:fansub' do |status, fansub|
    result = Show.all status: status.downcase.to_sym, fansub: fansub
    export result
  end

  # return all the shows with the given status
  get '/api/v1/shows/all/:status/?' do |status|
    result = Show.all status: status.downcase.to_sym
    export result
  end

  # return all the shows matching the given keyword
  get '/api/v1/shows/search/:keyword/?' do |keyword|
    result = Show.find_shows keyword
    export result
  end

  # return all the episodes of the given show
  get '/api/v1/episodes/:show/?' do |show|
    result = Episode.get_episodes show
    export result
  end
end