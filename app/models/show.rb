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
  property :tot_episodes, Integer, default: 13,  min: 0
  property :status,       Enum[ :ongoing, :finished, :dropped, :planned ], default: :ongoing
  property :airing,       Boolean, default: true
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

  sort_by :name.asc

  has n, :episodes, constraint: :destroy

  before :save do
    Show.roles.each do |r|
      instance_variable_set "@#{r}", self.send(r).gsub(?/, ?+)
    end
  end

  def count_episodes
    episodes.count
  end

  def complete?
    episodes.each { |e| return false unless e.done? }
    true
  end
    alias_method :done?, :complete?

  class << self
    def roles
      [ :translator, :editor, :checker, :timer, :typesetter, :encoder, :qchecker ]
    end

    def role?(role)
      Show.roles.include? role
    end
    
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

    def get_fansubs
      Show.all.map { |s| s.fansub.split(?+).map(&:strip) }.flatten.uniq
    end
  end
end
