require 'rails_helper'

RSpec.describe SmsService do
  it 'valid response' do
    mock_response = OpenStruct.new(message_id: SecureRandom.uuid)
    allow_any_instance_of(Aws::SNS::Client).to receive(:publish).and_return(mock_response)

    response = SmsService.publish(phone_number: 'phone number', message: 'sms content')
    expect(response.status).to be_truthy
  end

  it 'invalid response with Aws::SNS::Errors::InvalidParameter' do
    error_message = 'error messages'
    allow_any_instance_of(Aws::SNS::Client)
      .to receive(:publish).and_raise(Aws::SNS::Errors::InvalidParameter.new(nil, nil), error_message)

    response = SmsService.publish(phone_number: 'phone number', message: 'sms content')
    expect(response.status).to be_falsey
    expect(response.message).to eq error_message
  end

  it 'invalid response with other errors' do
    allow_any_instance_of(Aws::SNS::Client).to receive(:publish).and_return('Shoud be a OpenStruct')

    response = SmsService.publish(phone_number: 'phone number', message: 'sms content')
    expect(response.status).to be_falsey
    expect(response.message).to eq 'Internal Server Error'
  end
end
