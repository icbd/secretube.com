require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:phone_number_authed_user) { create(:user,
                                          phone_number_valid: true,
                                          phone_number: Faker::PhoneNumber.cell_phone) }
  let(:phone_number_unauth_user) { create(:user, phone_number_valid: false) }

  context 'valid' do
    it 'with factory' do
      notification = build(:notification)
      expect(notification).to be_valid
      expect(notification.save).to be_truthy
    end
  end

  context 'invalid' do
    it 'unauthed user can only send register sms' do
      Notification.categories.each do |key, value|
        if key == 'register'
          expect(build(:notification, user: phone_number_unauth_user, category: key)).to be_valid
        else
          expect(build(:notification, user: phone_number_unauth_user, category: key)).to_not be_valid
        end
      end
    end

    it 'authed user can send any type of sms, except register' do
      Notification.categories.each do |key, value|
        if key == 'register'
          expect(build(:notification, user: phone_number_authed_user, category: key)).to_not be_valid
        else
          expect(build(:notification, user: phone_number_authed_user, category: key)).to be_valid
        end
      end
    end
  end

  context 'execute' do
    let(:notification_to_advertise) { create(:notification, user: phone_number_authed_user, category: :advertise) }

    it 'success' do
      mock_response = double(status: true, message: 'message id')
      allow(SmsService).to receive(:publish).and_return(mock_response)

      result = notification_to_advertise.execute
      expect(result).to eq true
      expect(notification_to_advertise.successful?).to eq true
    end

    it 'failed' do
      mock_response = double(status: false, message: 'failed message')
      allow(SmsService).to receive(:publish).and_return(mock_response)

      result = notification_to_advertise.execute
      expect(result).to eq false
      expect(notification_to_advertise.failed?).to eq true
    end
  end

  context 'Notification.match?' do
    let(:notification_to_register) { create(:notification, user: phone_number_unauth_user, category: :register) }

    it 'generate code automatic when register' do
      expect(notification_to_register.verification_code_usage_count).to eq 0
      expect(notification_to_register.verification_code.present?).to be_truthy
    end

    it 'match with touch_usage_count: false' do
      match_result = Notification.matched?(user_id: notification_to_register.user_id,
                                           category: :register,
                                           code: notification_to_register.verification_code,
                                           touch_usage_count: false)

      expect(match_result).to be_truthy
      expect(notification_to_register.reload.verification_code_usage_count).to eq 0
    end

    it 'match with touch_usage_count: true' do
      match_result = Notification.matched?(user_id: notification_to_register.user_id,
                                           category: :register,
                                           code: notification_to_register.verification_code,
                                           touch_usage_count: true)

      expect(match_result).to be_truthy
      expect(notification_to_register.reload.verification_code_usage_count).to eq 1
    end

    it 'does not match' do
      match_result = Notification.matched?(user_id: notification_to_register.user_id,
                                           category: :register,
                                           code: 'this is a wrong code')

      expect(match_result).to be_falsey
      expect(notification_to_register.reload.verification_code_usage_count).to eq 0
    end
  end
end
