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
  get '/episode/add/?' do
    if not logged_in?
      @error = 'You need to log in.'
    elsif not current_user.staff?
      @error = 'Go home, this is not a place for you.'
    else
      @shows = Show.all
    end
    erb :'episode/add'
  end

  get '/episode/edit/?' do
    if not logged_in?
      @error = 'You need to log in.'
    elsif not current_user.staff?
      @error = 'Go home, this is not a place for you.'
    else
      @show  = Show.all
    end
    erb :'episode/edit'
  end

  get '/episode/delete/?' do
    if not logged_in?
      @error = 'You need to log in.'
    elsif not current_user.staff?
      @error = 'Go home, this is not a place for you.'
    else
      @show  = Show.all
    end
    erb :'episode/delete'
  end

  post '/episode/add/?' do
    if not logged_in?
      @error = 'You need to log in.'
    elsif not current_user.staff?
      @error = 'Go home, this is not a place for you.'
    elsif fields? :name, :go
      show   = Show.get_show params[:name]
      if show
        @show  = show
      else
        @error = 'Show not found.'
      end
    elsif not fields? :name, :episode
      @error = 'To add an episode, you need almost to send its name and what episode it is.'
    else
      data = {
        :translation => params[:translation] == 'on',
        :editing     => params[:editing    ] == 'on',
        :typesetting => params[:typesetting] == 'on',
        :encoding    => params[:encoding   ] == 'on',
        :checking    => params[:checking   ] == 'on',
        :timing      => params[:timing     ] == 'on',
        :qchecking   => params[:qchecking  ] == 'on'
      }

      episode = Episode.add params[:name], params[:episode].to_i, data
      if not episode
        @error   = 'Show not found'
      elsif episode.errors.any?
        @error   = episode.errors.first
      else
        @success = 'The episode has been added.'
      end
    end
    erb :'episode/add'
  end

  post '/episode/edit/?' do
    if not logged_in?
      @error = 'You need to log in.'
    elsif not current_user.staff?
      @error = 'Go home, this is not a place for you.'
    elsif not fields? :name, :episode
      @error = 'To edit an episode, you need almost to send its name and what episode it is.'
    elsif fields? :go
      episode = Episode.get_episode params[:name], params[:episode].to_i
      if episode
        @episode = episode
        @name    = params[:name]
      else
        @error   = 'Episode not found.'
      end
    else
      data = {
        :translation => params[:translation] == 'on',
        :editing     => params[:editing    ] == 'on',
        :typesetting => params[:typesetting] == 'on',
        :encoding    => params[:encoding   ] == 'on',
        :checking    => params[:checking   ] == 'on',
        :timing      => params[:timing     ] == 'on',
        :qchecking   => params[:qchecking  ] == 'on'
      }

      episode = Episode.edit params[:name], params[:episode].to_i, data
      if episode
        @success = 'The episode has been edited.'
      else
        @error   = 'Error editing the episode'
      end
    end
    erb :'episode/edit'
  end

  post '/episode/delete/?' do
    if not logged_in?
      @error = 'You need to log in.'
    elsif not current_user.staff?
      @error = 'Go home, this is not a place for you.'
    elsif not fields? :name, :episode
      @error = 'To delete an episode, you need almost to send its name and what episode it is.'
    else
      episode = Episode.remove params[:name], params[:episode].to_i
      if episode
        @success = 'The episode has been deleted.'
      else
        @error   = 'Error deleting the episode.'
      end
    end
    erb :'episode/edit'
  end
end