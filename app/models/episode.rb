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
  property :episode,     Integer, required: true, key: true

  property :translation, Boolean, default: false
  property :editing,     Boolean, default: false
  property :checking,    Boolean, default: false
  property :timing,      Boolean, default: false
  property :typesetting, Boolean, default: false
  property :encoding,    Boolean, default: false
  property :qchecking,   Boolean, default: false
  property :download,    Text

  property :created_at,  DateTime
  property :updated_at,  DateTime

  belongs_to :show

  def complete?
    Episode.tasks.each { |t|
      return false unless self.send t
    }
    true
  end

  class << self
    def tasks
      [ :translation, :editing, :checking, :timing, :typesetting, :encoding, :qchecking ]
    end

    def task?(task)
      Episode.tasks.include? task
    end

    def add(name, episode, stuff = {})
      return false if Episode.get_episode name, episode
      show = Show.first name: name
      return false unless show
      show.episodes.create({ episode: episode }.merge(stuff))
    end

    def edit(name, episode, stuff = {})
      episode = get_episode name, episode
      return false unless episode
      episode.update({ episode: episode }.merge(stuff))
    end

    def apply_globally(name, stuff = {})
      show = Show.get_show name
      return false unless show
      return true  if show.tot_episodes == 0

      0.tap { |fails|
        1.upto(show.tot_episodes) { |episode|
          if Episode.exists? name, episode
            fails += 1 unless Episode.edit name, episode, stuff
          else
            res = Episode.add name, episode, stuff
            fails += 1 if !res || res.errors.empty?
          end
        }
      } == 0
    end

    def remove(name, episode, stuff = {})
      episode = Episode.get_episode name, episode, stuff
      return false unless episode      
      episode.destroy
    end

    def exists?(name, episode, stuff = {})
      Episode.count({
        :episode   => episode,
        :show_name => name
      }.merge(stuff)) > 0
    end

    def get_episode(name, episode, stuff = {})
      Episode.first({
        :episode   => episode,
        :show_name => name
      }.merge(stuff))
    end

    def get_episodes(name, stuff = {})
      Episode.all({
        show_name: name
      }.merge(stuff))
    end

    def get_last_episode(name, stuff = {})
      Episode.last({
        show_name: name
      }.merge(stuff))
    end

    def last_episode(name, stuff = {})
      episode = get_last_episode name, stuff
      episode ? episode.episode : 0
    end

    def last_episodes(status)
      [].tap { |e|
        Show.all(status: status).each { |show|
          episodes   = show.episodes.all
          released   = episodes.select { |e|     e.complete? }
          unreleased = episodes.select { |e| not e.complete? }

          e << (unreleased.empty? ? released.last : unreleased.first)
        }
      }
    end
  end
end