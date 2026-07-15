updates = {
  'LOGO' => '/brand-assets/lakche-logo.png?v=20260713-2',
  'LOGO_DARK' => '/brand-assets/lakche-logo-dark.png?v=20260713-3',
  'LOGO_THUMBNAIL' => '/brand-assets/lakche-favicon.png?v=20260713-2',
  'INSTALLATION_NAME' => 'LakcheLink',
  'BRAND_NAME' => 'LAKCHE LLC',
  'BRAND_URL' => 'https://lakche.com',
  'WIDGET_BRAND_URL' => 'https://lakche.com'
}.freeze

updates.each do |key, value|
  row = InstallationConfig.find_or_initialize_by(name: key)
  row.value = value
  row.save!
end

GlobalConfig.clear_cache

puts GlobalConfig.get(
  'LOGO',
  'LOGO_DARK',
  'LOGO_THUMBNAIL',
  'INSTALLATION_NAME',
  'BRAND_NAME',
  'BRAND_URL',
  'WIDGET_BRAND_URL'
).to_h.inspect
