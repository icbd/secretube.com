class AddVerifyCodeToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications,
               :verification_code,
               :string,
               comment: '验证码'

    add_column :notifications,
               :verification_code_usage_count,
               :integer,
               default: 0,
               comment: '验证码使用次数'
  end
end
