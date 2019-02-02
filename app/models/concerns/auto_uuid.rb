module AutoUuid
  extend ActiveSupport::Concern

  included do
    validates :uuid, presence: true, uniqueness: true
    before_validation :init_uuid
  end

  private

  def init_uuid
    return if uuid.present?

    self.uuid = SecureRandom.uuid
  end
end
