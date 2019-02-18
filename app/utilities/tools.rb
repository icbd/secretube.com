module Tools
  class << self
    # 生产随机字符串
    # 仅包含字符和数字, 大小写敏感
    def generate_token(length = 20)
      SecureRandom.alphanumeric(length)
    end

    # 计算密码摘要
    # By BCrypt
    def digest_calc(origin_string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(origin_string, cost: cost)
    end

    # 密码是否匹配
    # By BCrypt
    def digest_auth?(origin_string, digest)
      return false if digest.blank?

      BCrypt::Password.new(digest).is_password?(origin_string)
    end

    # 验证码生成器, 仅数字
    def generate_verify_code(length: 4)
      codes = []
      length.times do
        codes << rand(10)
      end

      codes.join
    end
  end
end
