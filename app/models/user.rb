# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  email             :string           not null
#  email_valid       :boolean          default(FALSE)
#  forgot_pswd_token :string
#  nickname          :string
#  password_digest   :string
#  remember_me_token :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email)
#

class User < ApplicationRecord
  has_secure_password
  before_validation :init

  validates :email, allow_blank: true, format: {with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/}, uniqueness: true

  private

  def init
    self.nickname = self.email.to_s.split('@').first if nickname.blank?
  end
end
