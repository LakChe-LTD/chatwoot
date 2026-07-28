module Lakchelink
  module Branding
    DESIRED_CONFIG = {
      'LOGO' => '/brand-assets/logo.png?v=20260718-1',
      'LOGO_DARK' => '/brand-assets/logo_dark.png?v=20260718-1',
      'LOGO_THUMBNAIL' => '/brand-assets/logo_thumbnail.png?v=20260718-1',
      'INSTALLATION_NAME' => 'LakcheLink',
      'BRAND_NAME' => 'LAKCHE LLC',
      'BRAND_URL' => 'https://lakchelink.com',
      'WIDGET_BRAND_URL' => 'https://lakchelink.com',
      'TERMS_URL' => 'https://lakchelink.com',
      'PRIVACY_URL' => 'https://lakchelink.com',
      'DISPLAY_MANIFEST' => false
    }.freeze

    module_function

    def apply!
      DESIRED_CONFIG.each do |key, value|
        row = InstallationConfig.find_or_initialize_by(name: key)
        next if row.value == value

        row.value = value
        row.save!
      end

      GlobalConfig.clear_cache
      current_config
    end

    def current_config
      GlobalConfig.get(*DESIRED_CONFIG.keys).to_h
    end
  end
end
