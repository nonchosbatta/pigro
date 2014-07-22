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
      :translation => :ongoing,
      :editing     => :ongoing,
      :typesetting => :done,
      :encoding    => :done,
      :checking    => :nope,
      :timing      => :nope,
      :qchecking   => :nope
    }
  end

  it 'initializes correctly shows and episodes' do
    unless User.exists? @username
      user = User.signup @username, @email, @password, @level
      user.errors.should be_empty
      user.admin?.should be_truthy
    end

    User.login(@username, @password).should be_truthy

    show = Show.add @show_name, @show_data
    show.errors.should                      be_empty
    Show.first(name: @show_name).should_not be_nil
    
    episode = Episode.add         @show_name, @episode_number, @episode_data
    episode.should_not    be_falsy
    episode.errors.should be_empty

    episode = Episode.get_episode @show_name, @episode_number
    episode.should_not be_nil
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

  it 'calls shows/last/:status' do
    get '/api/v1/episodes/last/ongoing'
    last_response.should be_ok

    json = JSON.parse last_response.body
    json.should_not be_empty

    json.first['episode'].should eql(@episode_number)
  end

  it 'calls shows/search/:keyword' do
    get "/api/v1/shows/search/#{URI.escape @show_name[0..6]}"
    last_response.should be_ok

    json = JSON.parse last_response.body
    json.should_not be_empty

    json.first['name'].should eql(@show_name)
  end

  it 'calls fansubs/:fansub/shows/all/:status' do
    get '/api/v1/fansubs/GliShinbati/shows/all/ongoing'
    last_response.should be_ok

    json = JSON.parse last_response.body
    json.should_not be_empty

    json.first['fansub'].should eql('GliShinbati')
  end

  it 'calls users/:user/shows/all/:status' do
    get '/api/v1/users/Gustavo/shows/all/ongoing'
    last_response.should be_ok

    json = JSON.parse last_response.body
    json.should_not be_empty

    json.first['name'].should eql('Monogatari Series Second Season')
  end

  it 'calls users/:user/:role/shows/all/:status' do
    get '/api/v1/users/Gustavo/translator/shows/all/ongoing'
    last_response.should be_ok

    json = JSON.parse last_response.body
    json.should_not be_empty

    json.first['translator'].should eql('Gustavo')
  end

  it 'calls shows/episodes/:show' do
    get "/api/v1/episodes/#{URI.escape @show_name}"
    last_response.should be_ok

    json = JSON.parse last_response.body
    json.should_not be_empty

    json.first['episode'].to_i.should     eql(@episode_number)
    json.first['qchecking'].to_sym.should eql(@episode_data[:qchecking])
  end
end
