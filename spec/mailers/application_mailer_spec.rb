require 'rails_helper'

RSpec.describe ApplicationMailer do
  subject(:mailer) { described_class.new }

  describe '#smtp_config_set_or_development?' do
    it 'returns true when resend api is configured' do
      with_modified_env RESEND_API_KEY: 're_test_key', SMTP_ADDRESS: nil do
        expect(mailer.send(:smtp_config_set_or_development?)).to be(true)
      end
    end

    it 'returns true when smtp is configured' do
      with_modified_env RESEND_API_KEY: nil, SMTP_ADDRESS: 'smtp.example.com' do
        expect(mailer.send(:smtp_config_set_or_development?)).to be(true)
      end
    end
  end
end
