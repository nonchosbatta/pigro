#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

class Show
  include DataMapper::Resource

  property :id,           Serial
  property :name,         String,  unique: true, required: true, key: true
  property :tot_episodes, String,  default: 13
  property :status,       Enum[ :ongoing, :finished, :dropped ], default: :ongoing
  property :fansub,       String

  property :translator,   String
  property :editor,       String
  property :checker,      String
  property :timer,        String
  property :typesetter,   String
  property :encoder,      String
  property :qchecker,     String

  property :created_at,   DateTime
  property :updated_at,   DateTime

  has n, :episodes, constraint: :destroy

  class << self
    def add(name, stuff = {})
      Show.create({ name: name }.merge(stuff))
    end

    def edit(name, stuff = {})
      show = Show.first name: name
      return false unless show
      show.update stuff
    end

    def remove(name)
      show = Show.first name: name
      return false unless show
      show.destroy
    end

    def get_show(name)
      Show.first name: name
    end

    def find_shows(keyword)
      Show.all :name.like => "%#{keyword}%"
    end
    
  end
end