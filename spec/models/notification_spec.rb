require 'rails_helper'

RSpec.describe Notification, type: :model do
  context 'valid' do
    it 'with factory' do
      notification = build(:notification)
      expect(notification).to be_valid
      expect(notification.save).to be_truthy
    end
  end
end
