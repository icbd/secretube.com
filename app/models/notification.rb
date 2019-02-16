# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  category   :integer          not null
#  content    :string           not null
#  deleted_at :datetime
#  status     :integer          default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
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

  def execute
    response = send_sms
  end

  private

  def check_limit(time_limit: 1.minute.ago, count_limit: 2)
    sended_count = self.class
                       .where(user_id: user_id, category: category)
                       .where('created_at > ?', time_limit)
                       .count

    errors.add(:base, I18n.t('frequent')) if sended_count >= count_limit
  end

  def send_sms
    sns_client = Aws::SNS::Client.new(region: 'us-east-1',
                                      access_key_id: ENV['AWS_SMS_ACCESS_KEY_ID'],
                                      secret_access_key: ENV['AWS_SMS_SECRET_ACCESS_KEY'])
    sns_client.publish(phone_number: user.phone_number, message: content)
  end
end
