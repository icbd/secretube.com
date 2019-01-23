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
  validates :email, allow_blank: true, format: {with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/}
end
