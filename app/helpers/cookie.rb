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
  helpers do
    def set_cookie(key, value, path = '/', expires = nil)
      response.set_cookie key, {
        :value   => value,
        :path    => path,
        :expires => expires || Time.now + 24 * 60 * 60
      }
    end

    def get_cookie(key)
      request.cookies[key]
    end

    def cookie_exists?(key)
      !!get_cookie(key)
    end

    def delete_cookie(key)
      set_cookie key, '', '/', Time.now
    end
  end
end