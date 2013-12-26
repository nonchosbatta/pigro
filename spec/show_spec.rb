ENV['RACK_ENV'] = 'test'

require './spec'
require 'rspec'
require 'rack/test'

describe 'Pigro' do
  def app
    Sinatra::Application
  end

  before do
    @username = 'Giovanni'
    @email    = 'giovanni@caporocket.pk'
    @password = 'ernesto'
    @level    = User.admin

    @show_name    = 'Monogatari Series Second Season'
    @tot_episodes = 23
    @show_data    = {
      :tot_episodes => @tot_episodes,
      :airing       => 'tuesday at 19:00',
      :translator   => 'Gustavo',
      :editor       => 'Patrizio',
      :typesetter   => 'Clodovico',
      :encoder      => 'Ignazio',
      :checker      => 'Gripanzo',
      :timer        => 'Gertrudo',
      :qchecker     => 'Ernesto'
    }

    @episode_number = 3
    @episode_data   = {
      :translation => true,
      :editing     => false,
      :typesetting => true,
      :encoding    => true,
      :checking    => false,
      :timing      => false,
      :qchecking   => false
    }
  end

  it 'creates a show' do
    user = User.signup @username, @email, @password, @level
    user.errors.should                      be_empty
    user.admin?.should                      be_true
    User.login(@username, @password).should be_true

    show = Show.add @show_name, @show_data
    show.errors.should                      be_empty
    Show.first(name: @show_name).should_not be_nil
  end

  it 'edits a show' do
    data    = { checker: 'Arnoldo' }
    checker = Show.get_show(@show_name).checker

    show    = Show.edit @show_name, data
    show.should be_true

    Show.get_show(@show_name).checker.should_not be(checker)
  end

  it 'adds an episode to a show' do
    episode = Episode.add         @show_name, @episode_number, @episode_data
    episode.should_not    be_false
    episode.errors.should be_empty

    episode = Episode.get_episode @show_name, @episode_number
    episode.should_not         be_nil
    episode.translation.should be_true
    episode.editing.should     be_false
  end

  it 'edits an episode of a show' do
    data = {
      :translation => false,
      :editing     => true
    }
    
    episode = Episode.edit @show_name, @episode_number, data
    episode.should be_true

    episode = Episode.get_episode @show_name, @episode_number
    episode.translation.should be_false
    episode.editing.should     be_true
  end

  it 'removes an episode of a show' do
    episode = Episode.remove @show_name, @episode_number
    episode.should                                          be_true
    Episode.get_episode(@show_name, @episode_number).should be_nil
    Show.get_show(@show_name).should_not                    be_nil
  end

  it 'removes a show' do
    show = Show.remove @show_name
    show.should                      be_true
    Show.get_show(@show_name).should be_nil
  end

end
