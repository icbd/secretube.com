class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, index: true, unique: true, null: false, comment: "用户Email唯一, 非空"
      t.string :password_digest, comment: "密码hash"
      t.string :nickname, comment: "用户昵称, 展示用"
      t.boolean :email_valid, default: false, comment: "邮箱是否被激活"
      t.string :remember_me_token, comment: "记住我 令牌"
      t.string :forgot_pswd_token, comment: "找回密码 令牌"

      t.datetime :delete_at, index: true, comment: "软删除"

      t.timestamps
    end
  end
end
