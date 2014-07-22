describe 'Pigro' do
  def app
    Sinatra::Application
  end

  before do
    @username     = 'Gennaro'
    @email        = 'gennaro@bullo.pk'
    @password     = 'sonopropriounbullo!'
    @new_password = 'sonounnuovobullo'
    @level        = User.empty? ? User.founder : User.user
  end

  it 'creates an user' do
    User.exists?(@username).should be_falsy
    user = User.signup @username, @email, @password, @level
    user.errors.should             be_empty
    user.guest?.should             be_falsy
    user.founder?.should           be_truthy
    User.exists?(@username).should be_truthy

    user = User.signup @username, @email, @password, @level
    user.errors.should_not be_empty
  end

  it 'logs in a user' do
    User.exists?(@username).should          be_truthy
    User.login(@username, @password).should be_truthy

    user = User.get @username
    expect(user.session).to have(29).chars
  end

  it 'logs out a user' do
    user = User.get @username
    expect(user.session).to have(29).chars
    
    user.logout
    user.session.should be_empty
  end

  it 'recovers lost @password' do
    User.login(@username, @new_password).should be_falsy

    passcode = User.lost_password @username
    passcode.should_not be_falsy
    expect(passcode).to have(29).chars

    recovery = User.password_recovery @username, passcode, @new_password
    recovery.should be_truthy

    User.login(@username, @new_password).should be_truthy
  end

  it 'change the user @level' do
    User.login(@username, @new_password).should be_truthy
    
    user = User.get @username
    user.founder?.should be_truthy

    user.change_level User.banned
    user.banned?.should be_truthy
  end
end
