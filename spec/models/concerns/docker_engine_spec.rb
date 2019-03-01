require 'rails_helper'

RSpec.describe DockerEngine do
  let(:machine) { create(:machine) }

  def mock_create_container(response_body: { Id: 'container id' })
    mock_response = double(success?: true, body: JSON.generate(response_body))

    allow(machine).to receive(:create_container).and_return(mock_response)
  end

  def mock_start_container
    mock_response = double(success?: true)
    allow(machine).to receive(:start_container).and_return(mock_response)
  end

  it 'healthy?' do
    expect(machine.respond_to?(:version)).to be_truthy

    [true, false].each do |result|
      allow(machine).to receive(:version).and_return(double(success?: result))
      expect(machine.healthy?).to eq result
    end
  end

  it 'start_container stop_container need container name or id' do
    mock_create_container

    expect(machine.start_container).to eq nil
    expect(machine.stop_container).to eq nil
  end

  it 'run_container' do
    mock_create_container
    mock_start_container
    expect(machine.run_container(port: 1, password: 1, name: 1)).to be_truthy

    mock_create_container(response_body: {})
    expect(machine.run_container(port: 1, password: 1, name: 1)).to be_falsey

    mock_create_container(response_body: 'this is an illegal json string')
    expect(machine.run_container(port: 1, password: 1, name: 1)).to be_falsey
  end
end
