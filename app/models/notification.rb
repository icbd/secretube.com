# == Schema Information
#
# Table name: notifications
#
#  id                            :integer          not null, primary key
#  category                      :integer          not null
#  content                       :string           not null
#  deleted_at                    :datetime
#  description                   :text
#  status                        :integer          default("pending"), not null
#  verification_code             :string
#  verification_code_usage_count :integer          default(0)
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  user_id                       :integer          not null
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

  before_validation :init_verification_code, on: :create
  validates :category, :content, :user_id, presence: true
  validate :check_limit, on: :create
  validate :check_available, on: :create

  class << self
    def matched?(user_id:, category:, code:, available_timeout: 3.minute.ago, touch_usage_count: true)
      notification = where(user_id: user_id,
                           category: category,
                           verification_code: code,
                           verification_code_usage_count: 0)
                     .where('created_at > ?', available_timeout)
                     .order('id DESC')
                     .last

      return false unless notification

      if touch_usage_count
        notification.verification_code_usage_count += 1
        notification.save!
      end
      true
    end
  end

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
    SmsService.publish(phone_number: user.phone_number, message: content)
  end

  def init_verification_code
    return unless %i[register password].include?(category.to_sym)

    self.verification_code = Tools.generate_verify_code
    self.content = I18n.t("notification.#{category}_sms_template", verification_code: verification_code)
  end
end
