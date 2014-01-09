ENV['RACK_ENV'] = 'test'

require './spec'
require 'rspec'
require 'rack/test'
require 'json'

describe 'Pigro\'s APIs' do
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
      :fansub       => 'GliShinbati',
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

  it 'initializes correctly shows and episodes' do
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

  it 'uses CORS' do
    get '/api/v1/shows/all'
    last_response.headers['Access-Control-Allow-Origin'].should eql(?*)
  end

  it 'calls shows/all/:status' do
    get '/api/v1/shows/all/ongoing'
    last_response.should be_ok

    json = JSON.parse last_response.body
    json.should_not be_empty

    json.first['name'].should eql(@show_name)
  end

  it 'calls shows/all/:status/:fansub' do
    get '/api/v1/shows/all/ongoing/GliShinbati'
    last_response.should be_ok

    json = JSON.parse last_response.body
    json.should_not be_empty

    json.first['fansub'].should eql('GliShinbati')
  end

  it 'calls shows/search/:keyword' do
    get "/api/v1/shows/search/#{URI.escape @show_name[0..6]}"
    last_response.should be_ok

    json = JSON.parse last_response.body
    json.should_not be_empty

    json.first['name'].should eql(@show_name)
  end

  it 'calls shows/episodes/:show' do
    get "/api/v1/episodes/#{URI.escape @show_name}"
    last_response.should be_ok

    json = JSON.parse last_response.body
    json.should_not be_empty

    json.first['episode'].to_i.should eql(@episode_number)
    json.first['qchecking'].should    eql(@episode_data[:qchecking])
  end

end
