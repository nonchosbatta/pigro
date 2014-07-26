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
    result = Show.all status: status.downcase.to_sym, :fansub.like => "%#{fansub}%"
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

    result = Show.all :status => status.downcase.to_sym, :"#{role.to_sym}".like => "%#{user}%"
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

  # return the csrf token
  get '/api/v1/user/csrf_token/?' do
    result = {}

    if not logged_in?
      result[:status ] = :error
      result[:message] = 'You need to log in.'
    else
      result[:status ] = :success
      result[:message] = csrf_token
    end

    export result
  end

  # perform the user login
  post '/api/v1/user/login/?' do
    result = {}

    if not fields? :username, :password
      result[:status ] = :error
      result[:message] = 'You have to complete all the required fields.'
    elsif logged_in?
      result[:status ] = :error
      result[:message] = 'You are already logged in.'
    else
      session = User.login params[:username], params[:password]
      if session
        set_login! session
        result[:status ] = :success
        result[:message] = 'Login successful.'
      else
        result[:status ] = :error
        result[:message] = 'Login failed.'
      end
    end

    export result
  end

  # perform the user logout
  post '/api/v1/user/logout/?' do
    result = {}

    if logged_in?
      current_user.logout!
      delete_login!
      
      result[:status ] = :success
      result[:message] = 'Logout successful.'
    else
      result[:status ] = :error
      result[:message] = 'You are not logged in.'
    end

    export result
  end

  # edit an episode
  post '/api/v1/episode/edit/?' do
    result = {}

    if not logged_in?
      result[:status ] = :error
      result[:message] = 'You need to log in.'
    elsif not current_user.staffer?
      result[:status ] = :error
      result[:message] = 'Go home, this is not a place for you.'
    elsif not fields? :name
      result[:status ] = :error
      result[:message] = 'To edit an episode, you need at least to send its name.'
    elsif not fields? :episode
      result[:status ] = :error
      result[:message] = 'To edit an episode, you need at least to send its name and what episode it is.'
    else
      unless Episode.get_episode params[:name], params[:episode].to_i
        result[:status ] = :error
        result[:message] = 'Show or episode not found.'
      else
        inputs = params.dup
        inputs[:translator] ||= inputs[:translation]
        inputs[:editor    ] ||= inputs[:editing    ]
        inputs[:checker   ] ||= inputs[:checking   ]
        inputs[:timer     ] ||= inputs[:timing     ]
        inputs[:typesetter] ||= inputs[:typesetting]
        inputs[:encoder   ] ||= inputs[:encoding   ]
        inputs[:qchecker  ] ||= inputs[:qchecking  ]
        inputs[:qc        ] ||= inputs[:qchecking  ]

        data = {
          :translation => inputs[:translation] ? inputs[:translation].to_sym : nil,
          :editing     => inputs[:editing    ] ? inputs[:editing    ].to_sym : nil,
          :checking    => inputs[:checking   ] ? inputs[:checking   ].to_sym : nil,
          :timing      => inputs[:timing     ] ? inputs[:timing     ].to_sym : nil,
          :typesetting => inputs[:typesetting] ? inputs[:typesetting].to_sym : nil,
          :encoding    => inputs[:encoding   ] ? inputs[:encoding   ].to_sym : nil,
          :qchecking   => inputs[:qchecking  ] ? inputs[:qchecking  ].to_sym : nil,
          :airing      => inputs[:airing     ] ? inputs[:airing     ] == 'true' : nil,
          :download    => inputs[:download   ]
        }

        if Episode.edit params[:name], params[:episode].to_i, data
          result[:status ] = :success
          result[:message] = 'The episode has been edited.'
        else
          result[:status ] = :error
          result[:message] = 'Error editing the episode'
        end
      end
    end

    export result
  end
end