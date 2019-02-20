class AddDomainToMachines < ActiveRecord::Migration[5.2]
  def change
    add_column :machines, :domain, :string
    add_column :machines, :docker_daemon_port, :integer, null: false, default: 23_000
  end
end
