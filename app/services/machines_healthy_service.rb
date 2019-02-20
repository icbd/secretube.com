class MachinesHealthyService
  class << self
    # @return
    # {
    #   'user_id_1': ['error_ip_1'],
    #   'user_id_2': ['error_ip_2', 'error_ip_3'],
    # }
    def check
      errors = {}
      Machine.serving.find_each do |machine|
        unless machine.healthy?
          machine.closed!

          ip_list = errors.fetch(machine.admin_user_id, [])
          ip_list << machine.ipv4
          errors[machine.admin_user_id] = ip_list
        end
      end

      errors.each do |admin_user_id, ipv4_list|
        user = User.find_by(id: admin_user_id)

        SmsService.publish(phone_number: user.phone_number, message: ipv4_list.join(' | ')) if user&.phone_number_valid?
      end
    end
  end
end
