require 'rails_helper'

RSpec.describe Tools do
  it 'generate_verify_code' do
    code = Tools.generate_verify_code(length: 10)
    expect(code.length).to eq 10
  end

  it 'generate_token' do
    token1 = Tools.generate_token(length: 32)
    token2 = Tools.generate_token(length: 32)

    expect(token1.length == 32).to be_truthy
    expect(token1 != token2).to be_truthy
  end

  it 'digest_auth?' do
    token = Tools.generate_token
    digest = Tools.digest_calc(token)

    expect(Tools.digest_auth?(origin_string: token, digest: digest)).to be_truthy
    expect(Tools.digest_auth?(origin_string: "wrong token", digest: digest)).to be_falsey
  end
end