ENV['RACK_ENV'] = 'test'

require './spec'
require 'rspec'
require 'rack/test'
require 'json'

describe 'Pigro' do
  include Rack::Test::Methods

  def app
    @app ||= Pigro.new
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
      :airing       => '2013-12-21 15:30:00+00:00',
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

  it 'initialize correctly shows and episodes' do
    unless User.exists? @username
      user = User.signup @username, @email, @password, @level
      user.errors.should be_empty
      user.admin?.should be_true
    end

    User.login(@username, @password).should be_true

    show = Show.add @show_name, @show_data
    show.errors.should                      be_empty
    Show.first(name: @show_name).should_not be_nil
    
    episode = Episode.add         @show_name, @episode_number, @episode_data
    episode.should_not    be_false
    episode.errors.should be_empty

    episode = Episode.get_episode @show_name, @episode_number
    episode.should_not    be_nil
  end

  it 'calls shows/all.json' do
    get '/api/shows/all.json'
    last_response.should be_ok

    json = JSON.parse last_response.body
    json.should_not be_empty

    json.first['name'].should eql(@show_name)
  end

  it 'calls shows/search/:keyword.json' do
    get "/api/shows/search/#{URI.escape @show_name[0..6]}.json"
    last_response.should be_ok

    json = JSON.parse last_response.body
    json.should_not be_empty

    json.first['name'].should eql(@show_name)
  end

  it 'calls shows/get/:show.json' do
    get "/api/shows/get/#{URI.escape @show_name}.json"
    last_response.should be_ok

    json = JSON.parse last_response.body
    json.should_not be_empty

    json['tot_episodes'].to_i.should eql(@tot_episodes)
  end

  it 'calls shows/get/:show/episodes/list.json' do
    get "/api/shows/get/#{URI.escape @show_name}/episodes/list.json"
    last_response.should be_ok

    json = JSON.parse last_response.body
    json.should_not be_empty

    json.first['episode'].to_i.should eql(@episode_number)
  end

  it 'calls shows/get/:show/episodes/get/:episode.json' do
    get "/api/shows/get/#{URI.escape @show_name}/episodes/get/#{@episode_number}.json"
    last_response.should be_ok

    json = JSON.parse last_response.body
    json.should_not be_empty

    json['episode'].to_i.should eql(@episode_number)
    json['qchecking'].should    eql(@episode_data[:qchecking])
  end

end
