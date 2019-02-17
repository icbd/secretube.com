# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  category    :integer          not null
#  content     :string           not null
#  deleted_at  :datetime
#  description :text
#  status      :integer          default("pending"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_notifications_on_deleted_at  (deleted_at)
#

class Notification < ApplicationRecord
  require 'aws-sdk'

  belongs_to :user

  enum category: {
    register: 1,
    password: 2,
    notify: 3,
    advertise: 4
  }

  enum status: {
    pending: 1,
    successful: 2,
    failed: 3
  }

  validates :category, :content, :user_id, presence: true
  validate :check_limit, on: :create
  validate :check_available, on: :create

  def execute
    return unless valid?

    sms_response = send_sms
    self.description = sms_response.message
    sms_response.status ? successful! : failed!

    successful?
  end

  private

  def check_limit(time_limit: 1.minute.ago, count_limit: 2)
    sended_count = self.class
                       .where(user_id: user_id, category: category)
                       .where('created_at > ?', time_limit)
                       .count

    errors.add(:base, I18n.t('frequent')) if sended_count >= count_limit
  end

  def check_available
    if user.phone_number_valid?
      # authed user
      errors.add(:base, I18n.t('notification.auth_phone_number')) if register?
    else
      # new user
      errors.add(:base, I18n.t('notification.authed_phone_number')) unless register?
    end
  end

  # @return
  # Struct::SMSResponse
  def send_sms
    sns_client = Aws::SNS::Client.new(region: 'us-east-1',
                                      access_key_id: ENV['AWS_SMS_ACCESS_KEY_ID'],
                                      secret_access_key: ENV['AWS_SMS_SECRET_ACCESS_KEY'],
                                      http_wire_trace: !Rails.env.production?)
    Struct.new('SMSResponse', :status, :message) unless 'Struct::SMSResponse'.safe_constantize

    begin
      response = sns_client.publish(phone_number: user.phone_number, message: content)

      Struct::SMSResponse.new(true, response.message_id)
    rescue Aws::SNS::Errors::InvalidParameter => exp
      Struct::SMSResponse.new(false, exp.to_s)
    end
  end
end
