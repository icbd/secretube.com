class CreateMachines < ActiveRecord::Migration[5.2]
  def change
    create_table :machines do |t|
      t.string :uuid, index: true, unique: true, null: false
      t.text :description

      t.text :public_key, comment: '公钥'
      t.text :private_key, comment: '私钥'

      t.string :ipv4, index: true, unique: true, null: false
      t.string :ipv6, index: true, unique: true, comment: 'optional'

      t.integer :max_support_amount, default: 100, comment: '最大服务数'
      t.integer :count_of_channels, default: 0, commnet: '已服务频道数 (counter cache)'

      t.integer :admin_user_id

      t.datetime :deleted_at, index: true, comment: '软删除'

      t.timestamps
    end
  end
end
