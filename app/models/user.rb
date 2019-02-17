# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  deleted_at         :datetime
#  email              :string           not null
#  email_valid        :boolean          default(FALSE)
#  forgot_pswd_token  :string
#  nickname           :string
#  password_digest    :string
#  phone_number       :string
#  phone_number_valid :boolean          default(FALSE)
#  remember_me_token  :string
#  uuid               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_users_on_deleted_at  (deleted_at)
#  index_users_on_email       (email)
#  index_users_on_uuid        (uuid)
#

class User < ApplicationRecord
  include AutoUuid
  has_secure_password
  before_validation :init
  after_validation :reset_errors_messages

  has_many :notifications

  validates :email, allow_blank: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
  validates :email, uniqueness: true

  private

  def init
    self.nickname = email.to_s.split('@').first if nickname.blank?
  end

  def reset_errors_messages
    return if errors[:password_confirmation].blank?

    errors[:password_confirmation].clear
    errors.add(:password_confirmation, I18n.t('not_match'))
  end
end
