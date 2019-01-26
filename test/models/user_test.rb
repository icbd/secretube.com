require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user__create" do
    assert_difference "User.count", +1 do
      user1 = create(:user, pswd: "NEW_PASSWORD")
      assert Tools.digest_auth?("NEW_PASSWORD", user1.password_digest)
      assert_not Tools.digest_auth?("WRONG_PASSWORD", user1.password_digest)

      # MARK:
      # assert_difference block内的变量不能在外面用, user1也会在block结束的时候销毁
    end
  end

  test "user__valid_email" do
    user = create(:user)
    legal_list = %w{abc@gmail.com ABC123@Gmail.COM 123@qq.com hello+123@gmail.com c.bd+test@yahoo.com.cn}
    legal_list.each do |legal_email|
      user.email = legal_email
      assert user.valid?
    end

    illegal_list = %w{abc abc@ abc@@ abc@gmail@ abc@gmail@com abc@gmail. abc.com}
    illegal_list.each do |illegal_email|
      user.email = illegal_email
      assert_not user.valid?
    end
  end

  test "user__unique_email" do
    user = create(:user)

    user_double = build(:user, email: user.email)
    assert_not user_double.valid?
    assert user_double.errors[:email].present?
  end

  test "user__password_digest" do
    pswd = SecureRandom.alphanumeric(32)

    user = User.new(email: Faker::Internet.email, password: pswd, password_confirmation: "wrong password")
    assert_not user.valid?

    user.password_confirmation = pswd
    assert user.valid?

    user.save!

    assert user.authenticate(pswd)
    assert_not user.authenticate("wrong password")
  end


end
