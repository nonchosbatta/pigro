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
    def fields?(*args)
      args.each { |a|
        return false unless params.include? a.to_s
      }
      true
    end

    def export(collection, options = {})
      format  = options.include?(:as)      ? options[:as].to_sym : :json
      only    = options.include?(:only)    ? options[:only]      : []
      exclude = options.include?(:exclude) ? options[:exclude]   : []
      methods = options.include?(:methods) ? options[:methods]   : []

      case format
        when :xml  then collection.to_xml  only: only, exclude: exclude, methods: methods
        when :csv  then collection.to_csv  only: only, exclude: exclude, methods: methods
        when :yaml then collection.to_yaml only: only, exclude: exclude, methods: methods
        else            collection.to_json only: only, exclude: exclude, methods: methods
      end
    end
  end
end