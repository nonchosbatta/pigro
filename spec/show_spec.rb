ENV['RACK_ENV'] = 'test'

require './spec'
require 'rspec'
require 'rack/test'

describe 'Pigro' do
  def app
    Sinatra::Application
  end

  it 'creates a show' do
    username = 'Giovanni'
    email    = 'giovanni@caporocket.pk'
    password = 'ernesto'
    level    = User.admin

    user = User.signup username, email, password, level
    user.errors.should                    be_empty
    user.admin?.should                    be_true
    User.login(username, password).should be_true

    name = 'Monogatari Series Second Season'
    data = {
      :tot_episodes => 23,
      :airing       => '2013-12-21 15:30:00+00:00',
      :translator   => 'Gustavo',
      :editor       => 'Patrizio',
      :typesetter   => 'Clodovico',
      :encoder      => 'Ignazio',
      :checker      => 'Gripanzo',
      :timer        => 'Gertrudo',
      :qchecker     => 'Ernesto'
    }

    show = Show.add name, data
    show.errors.should                be_empty
    Show.first(name: name).should_not be_nil
  end

  it 'edits a show' do
    name = 'Monogatari Series Second Season'
    data = { checker: 'Arnoldo' }

    checker = Show.get_show(name).checker

    show  = Show.edit name, data
    show.should be_true

    Show.get_show(name).checker.should_not be(checker)
  end

  it 'adds an episode to a show' do
    name      = 'Monogatari Series Second Season'
    n_episode = 3
    data      = {
      :translation => true,
      :editing     => false,
      :typesetting => true,
      :encoding    => true,
      :checking    => false,
      :timing      => false,
      :qchecking   => false
    }
    
    episode = Episode.add name, n_episode, data
    episode.should_not    be_false
    episode.errors.should be_empty

    episode = Episode.get_episode name, n_episode
    episode.should_not         be_nil
    episode.translation.should be_true
    episode.editing.should     be_false
  end

  it 'edits an episode of a show' do
    name      = 'Monogatari Series Second Season'
    n_episode = 3
    data      = {
      :translation => false,
      :editing     => true
    }
    
    episode = Episode.edit name, n_episode, data
    episode.should be_true

    episode = Episode.get_episode name, n_episode
    episode.translation.should be_false
    episode.editing.should     be_true
  end

  it 'removes an episode of a show' do
    name      = 'Monogatari Series Second Season'
    n_episode = 3

    episode = Episode.remove name, n_episode
    episode.should                              be_true
    Episode.get_episode(name, n_episode).should be_nil
    Show.get_show(name).should_not              be_nil
  end

  it 'removes a show' do
    name = 'Monogatari Series Second Season'

    show = Show.remove name
    show.should                be_true
    Show.get_show(name).should be_nil
  end

end
