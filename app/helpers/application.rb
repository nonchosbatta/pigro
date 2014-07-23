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
    def cross_origin
      headers({
        'Access-Control-Allow-Origin'  => ?*,
        'Access-Control-Allow-Methods' => ['OPTIONS', 'GET']
      })
    end

    def fields?(*args)
      args.each { |a|
        return false unless params.include? a.to_s
      }
      true
    end

    def export(collection, options = {}, callback = nil)
      only    = options.include?(:only)    ? options[:only]      : []
      exclude = options.include?(:exclude) ? options[:exclude]   : []
      methods = options.include?(:methods) ? options[:methods]   : []

      res = collection.to_json only: only, exclude: exclude, methods: methods

      if callback
        content_type :js
        "#{callback}(#{res})"
      else
        content_type :json
        res
      end
    end

    def current_menu?(*menu)
      return false unless @title

      menu.each { |e| return true if @title.include?(e) }
      false
    end

    def current_action
      request.env['REQUEST_URI'].split(?/).join(' ').strip
    end
  end
end