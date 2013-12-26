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
  before do
    @language    = request.env['HTTP_ACCEPT_LANGUAGE']
    @current_url = "http://#{request.env['HTTP_HOST']}#{request.env['REQUEST_URI']}"
    @domain      = "http://#{request.env['HTTP_HOST']}"
  end

  get '/' do
    erb :index
  end
end