require 'rails_helper'

RSpec.describe SessionsHelper do
  include SessionsHelper
  let(:user) { create(:user) }

  it 'login and logout' do
    expect(logged_in?).to be_falsey
    login(user)
    expect(logged_in?).to be_truthy
    logout
    expect(logged_in?).to be_falsey
  end

  it 'current user' do
    expect(current_user).to be_falsey
    login(user)
    expect(current_user).to be_truthy
    expect(current_user == user).to be_truthy
  end
end
