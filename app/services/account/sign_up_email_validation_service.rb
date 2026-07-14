# frozen_string_literal: true

class Account::SignUpEmailValidationService
  include CustomExceptions::Account
  attr_reader :email, :skip_domain_validation

  def initialize(email, skip_domain_validation: false)
    @email = email
    @skip_domain_validation = skip_domain_validation
  end

  def perform
    address = ValidEmail2::Address.new(email)

    raise InvalidEmail.new({ valid: false, disposable: nil }) unless address.valid?

    raise InvalidEmail.new({ domain_blocked: true }) if domain_blocked?

    raise InvalidEmail.new({ valid: true, disposable: true }) if address.disposable?

    true
  end

  private

  def domain_blocked?
    return false if skip_domain_validation

    domain = email.split('@').last&.downcase
    blocked_domains.any? { |blocked_domain| domain.match?(blocked_domain.downcase) }
  end

  def blocked_domains
    domains = GlobalConfigService.load('BLOCKED_EMAIL_DOMAINS', '')
    return [] if domains.blank?

    domains.split("\n").map(&:strip)
  end
end
