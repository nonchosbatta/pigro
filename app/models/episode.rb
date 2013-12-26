#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

class Episode
  include DataMapper::Resource

  property :id,          Serial
  property :episode,     Integer, unique: true, required: true, key: true

  property :translation, Boolean, default: false
  property :editing,     Boolean, default: false
  property :checking,    Boolean, default: false
  property :timing,      Boolean, default: false
  property :typesetting, Boolean, default: false
  property :encoding,    Boolean, default: false
  property :qchecking,   Boolean, default: false

  property :created_at,  DateTime
  property :updated_at,  DateTime

  belongs_to :show

  class << self
    def add(name, episode, stuff = {})
      show = Show.first name: name
      return false unless show
      show.episodes.create({ episode: episode }.merge(stuff))
    end

    def edit(name, episode, stuff = {})
      show = Show.first name: name
      return false unless show
      _episode = show.episodes.first episode: episode
      return false unless _episode
      _episode.update({ episode: episode }.merge(stuff))
    end

    def remove(name, episode, stuff = {})
      show = Show.first name: name
      return false unless show
      _episode = show.episodes.first({ episode: episode }.merge(stuff))
      return false unless _episode      
      _episode.destroy
    end

    def get_episode(name, episode, stuff = {})
      Episode.first({
        :episode => episode,
        :show    => { name: name }
      }.merge(stuff))
    end

    def get_episodes(name, stuff = {})
      Episode.all({
        :show => { name: name }
      }.merge(stuff))
    end

    def last_episode(name, stuff = {})
      episode = Episode.last({
        :show => { name: name }
      }.merge(stuff))
      
      episode ? episode.episode : 0
    end
  end
end