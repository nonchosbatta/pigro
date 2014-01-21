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

  property :id,           Serial
  property :episode,      Integer, required: true, key: true
  property :last_episode, Boolean, default: false

  property :translation,  Enum[ :nope, :done, :ongoing ], default: :nope
  property :editing,      Enum[ :nope, :done, :ongoing ], default: :nope
  property :checking,     Enum[ :nope, :done, :ongoing ], default: :nope
  property :timing,       Enum[ :nope, :done, :ongoing ], default: :nope
  property :typesetting,  Enum[ :nope, :done, :ongoing ], default: :nope
  property :encoding,     Enum[ :nope, :done, :ongoing ], default: :nope
  property :qchecking,    Enum[ :nope, :done, :ongoing ], default: :nope
  property :download,     Text

  property :created_at,   DateTime
  property :updated_at,   DateTime

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

    def update_last_episode(show)
      return unless show
      
      episodes   = show.episodes.all
      released   = episodes
      unreleased = episodes.select { |e| not e.complete? }

      ep = unreleased.empty? ? released.last : unreleased.first
      if ep
        episodes.update last_episode: false
        ep.update       last_episode: true
      end
    end

    def add(name, episode, stuff = {}, update = true)
      return false if Episode.get_episode name, episode
      show = Show.first name: name
      return false unless show
      show.episodes.create({ episode: episode }.merge(stuff)).tap { |r|
        Episode.update_last_episode(show) if update
      }
    end

    def edit(name, episode, stuff = {}, update = true)
      episode = get_episode name, episode
      return false unless episode
      episode.update({ episode: episode }.merge(stuff)).tap { |r|
        Episode.update_last_episode(episode.show) if update
      }
    end

    def apply_globally(name, stuff = {}, from = 1, episodes = 0)
      show = Show.get_show name
      return false unless show
      return true  if show.tot_episodes == 0

      to = episodes > 0 ? episodes : show.tot_episodes
      0.tap { |fails|
        from.upto(to) { |episode|
          last = episode == episodes
          if Episode.exists? name, episode
            fails += 1 unless Episode.edit name, episode, stuff, last
          else
            res = Episode.add name, episode, stuff, last
            fails += 1 unless res || res.errors.any?
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
      Episode.all last_episode: true, show: { status: status }
    end
  end
end