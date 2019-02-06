require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid whit email and password' do
    user = User.create(email: Faker::Internet.email, password: 'password')
    expect(user).to be_valid
  end

  it 'is invalid with a duplicate email address' do
    user = create(:user)
    expect(user).to be_valid

    dup_user = user.dup
    expect(dup_user).to_not be_valid
    expect(dup_user.errors.key?(:email)).to be_truthy
  end

  it 'is valid with legal email format' do
    user = create(:user)
    emails = %w[abc@gmail.com ABC123@Gmail.COM 123@qq.com hello+123@gmail.com c.bd+test@yahoo.com.cn]
    emails.each do |email|
      user.email = email
      expect(user).to be_valid
    end
  end

  it 'is invalid with illegal email format' do
    user = create(:user)
    emails = %w[abc abc@ abc@@ abc@gmail@ abc@gmail@com abc@gmail. abc.com]
    emails.each do |email|
      user.email = email
      expect(user).to_not be_valid
    end
  end

  it 'is valid with right password and password confirmation' do
    pswd = SecureRandom.alphanumeric(32)
    user = build(:user, password: pswd, password_confirmation: 'wrong password')
    expect(user).to_not be_valid
    user.password_confirmation = pswd
    expect(user).to be_valid
  end

  it 'is authenticated with right password' do
    pswd = SecureRandom.alphanumeric(32)
    user = create(:user, password: pswd)
    expect(user.authenticate(pswd)).to be_truthy
    expect(user.authenticate('wrong password')).to be_falsey
  end
end
