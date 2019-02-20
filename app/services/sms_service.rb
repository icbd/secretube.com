class SmsService
  class << self
    # @return
    # Struct::SMSResponse
    def publish(phone_number:, message:)
      @sms_client ||= Aws::SNS::Client.new(region: 'us-east-1',
                                           access_key_id: ENV['AWS_SMS_ACCESS_KEY_ID'],
                                           secret_access_key: ENV['AWS_SMS_SECRET_ACCESS_KEY'],
                                           http_wire_trace: !Rails.env.production?)
      begin
        response = @sms_client.publish(phone_number: phone_number, message: message)

        OpenStruct.new(status: true, message: response.message_id)
      rescue Aws::SNS::Errors::InvalidParameter => exp
        OpenStruct.new(status: false, message: exp.to_s)
      end
    end
  end
end
