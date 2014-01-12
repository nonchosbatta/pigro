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

  # return all the shows having the given status
  get '/api/v1/shows/all/:status/?' do |status|
    result = Show.all status: status.downcase.to_sym
    export result
  end

  # return all the shows matching the given keyword
  get '/api/v1/shows/search/:keyword/?' do |keyword|
    result = Show.find_shows keyword
    export result
  end

  # return all the shows having the given status and fansub
  get '/api/v1/fansubs/:fansub/shows/all/:status' do |fansub, status|
    result = Show.all status: status.downcase.to_sym, fansub: fansub
    export result
  end

  # return all the shows where the given fansubber has worked
  get '/api/v1/users/:user/shows/all/:status' do |user, status|
    result = Show.all(status: status.downcase.to_sym) & (
              Show.all(:translator => user) |
              Show.all(:editor     => user) |
              Show.all(:checker    => user) |
              Show.all(:timer      => user) |
              Show.all(:typesetter => user) |
              Show.all(:encoder    => user) |
              Show.all(:qchecker   => user)
            )
    export result
  end

  # return all the shows where the given fansubber has worked at the given role
  get '/api/v1/users/:user/:role/shows/all/:status' do |user, role, status|
    export nil unless Show.role? role.to_sym

    result = Show.all :status => status.downcase.to_sym, :"#{role.to_sym}" => user
    export result
  end

  # return the first of non-completed episodes of all the series having the given status
  get '/api/v1/episodes/last/:status/?' do |status|
    result = Episode.last_episodes status
    export result
  end

  # return all the episodes of the given show
  get '/api/v1/episodes/:show/?' do |show|
    result = Episode.get_episodes show
    export result
  end
end