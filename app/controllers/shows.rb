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
  get '/show/add/?' do
    if not logged_in?
      @error = 'You need to log in.'
    elsif not current_user.staffer?
      @error = 'Go home, this is not a place for you.'
    end
    erb :'show/add'
  end

  get '/show/edit/?' do
    if not logged_in?
      @error = 'You need to log in.'
    elsif not current_user.staffer?
      @error = 'Go home, this is not a place for you.'
    else
      @shows = Show.all
    end
    erb :'show/edit'
  end

  get '/show/delete/?' do
    if not logged_in?
      @error = 'You need to log in.'
    elsif not current_user.staffer?
      @error = 'Go home, this is not a place for you.'
    else
      @shows = Show.all
    end
    erb :'show/delete'
  end

  post '/show/add/?' do
    if not logged_in?
      @error = 'You need to log in.'
    elsif not current_user.staffer?
      @error = 'Go home, this is not a place for you.'
    elsif not fields? :name
      @error = 'To add a show, you need at least to send its name.'
    else
      data   = {
        :tot_episodes => params[:tot_episodes].to_i,
        :fansub       => params[:fansub      ],
        :translator   => params[:translator  ],
        :editor       => params[:editor      ],
        :checker      => params[:checker     ],
        :timer        => params[:timer       ],
        :typesetter   => params[:typesetter  ],
        :encoder      => params[:encoder     ],
        :qchecker     => params[:qchecker    ],
        :status       => params[:status      ].downcase.gsub(/\s+/, '').to_sym
      }

      show = Show.add params[:name], data
      if show.errors.any?
        @error   = show.errors.first.first
      else
        @success = 'The show has been added.'
      end
    end
    erb :'show/add'
  end

  post '/show/edit/?' do
    if not logged_in?
      @error = 'You need to log in.'
    elsif not current_user.staffer?
      @error = 'Go home, this is not a place for you.'
    elsif not fields? :name
      @error = 'To edit a show, you need to send its name.'
    elsif fields? :go
      show   = Show.get_show params[:name]
      if show
        @show  = show
      else
        @error = 'Show not found.'
      end
    else
      data = {
        :tot_episodes => params[:tot_episodes].to_i,
        :fansub       => params[:fansub      ],
        :translator   => params[:translator  ],
        :editor       => params[:editor      ],
        :checker      => params[:checker     ],
        :timer        => params[:timer       ],
        :typesetter   => params[:typesetter  ],
        :encoder      => params[:encoder     ],
        :qchecker     => params[:qchecker    ],
        :status       => params[:status      ].downcase.gsub(/\s+/, '').to_sym
      }

      if Show.edit params[:name], data
        @success = 'The show has been edited.'
      else
        @error   = 'Error editing the show.'
      end
    end
    erb :'show/edit'
  end

  post '/show/delete/?' do
    if not logged_in?
      @error = 'You need to log in.'
    elsif not current_user.staffer?
      @error = 'Go home, this is not a place for you.'
    elsif not fields? :name
      @error = 'To delete a show, you have to send its name.'
    else
      if Show.remove params[:name]
        @success = 'The show has been deleted.'
      else
        @error   = 'Error deleting the show.'
      end
    end
    erb :'show/delete'
  end
end