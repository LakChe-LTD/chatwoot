module Lakchelink
  module Branding
    DESIRED_CONFIG = {
      'LOGO' => '/brand-assets/lakche-logo.png?v=20260713-2',
      'LOGO_DARK' => '/brand-assets/lakche-logo-dark.png?v=20260713-3',
      'LOGO_THUMBNAIL' => '/brand-assets/lakche-favicon.png?v=20260713-2',
      'INSTALLATION_NAME' => 'LakcheLink',
      'BRAND_NAME' => 'LAKCHE LLC',
      'BRAND_URL' => 'https://lakche.com',
      'WIDGET_BRAND_URL' => 'https://lakche.com'
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
