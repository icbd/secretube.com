# == Schema Information
#
# Table name: machines
#
#  id                 :integer          not null, primary key
#  count_of_channels  :integer          default(0)
#  deleted_at         :datetime
#  description        :text
#  docker_daemon_port :integer          default(23000), not null
#  domain             :string
#  ipv4               :string           not null
#  ipv6               :string
#  max_support_amount :integer          default(100)
#  private_key        :text
#  public_key         :text
#  status             :integer          default("pending"), not null
#  uuid               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  admin_user_id      :integer
#
# Indexes
#
#  index_machines_on_deleted_at  (deleted_at)
#  index_machines_on_ipv4        (ipv4)
#  index_machines_on_ipv6        (ipv6)
#  index_machines_on_uuid        (uuid)
#

class Machine < ApplicationRecord
  include AutoUuid
  include DockerEngine

  enum status: {
    pending: 1,
    serving: 2,
    closed: 3
  }

  validates :ipv4, presence: true, uniqueness: true
  validates :max_support_amount, numericality: { greater_than_or_equal_to: 0 }
  validate :validate_count_of_channel

  private

  def validate_count_of_channel
    errors.add(:count_of_channels, 'Out of range.') unless count_of_channels.between?(0, max_support_amount)
  end
end
