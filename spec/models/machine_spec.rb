require 'rails_helper'

RSpec.describe Machine, type: :model do
  describe 'besic attributes' do
    let(:machine) { create(:machine) }

    it 'is valid with factory create' do
      expect(machine).to be_valid
    end

    it 'is invalid with illegal max_support_amount' do
      machine.max_support_amount = 10
      expect(machine).to be_valid

      machine.max_support_amount = -10
      expect(machine).to_not be_valid
    end

    it 'is invalid with illegal count_of_channels' do
      machine.update(max_support_amount: 10)

      machine.count_of_channels = 0
      expect(machine).to be_valid

      machine.count_of_channels = -10
      expect(machine).to_not be_valid

      machine.count_of_channels = machine.max_support_amount + 1
      expect(machine).to_not be_valid
    end

    it 'is invalid without ipv4' do
      machine = build(:machine, ipv4: nil)
      expect(machine).to_not be_valid
    end
  end
end
