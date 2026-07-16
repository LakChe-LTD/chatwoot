namespace :lakchelink do
  desc 'Apply LakcheLink branding values to installation config'
  task apply_branding: :environment do
    puts Lakchelink::Branding.apply!.inspect
  end
end

Rake::Task['db:seed'].enhance do
  next unless ActiveRecord::Base.connection.table_exists?('installation_configs')

  puts 'Applying LakcheLink branding'
  puts Lakchelink::Branding.apply!.inspect
end

Rake::Task['db:migrate'].enhance do
  next unless ActiveRecord::Base.connection.table_exists?('installation_configs')

  puts 'Applying LakcheLink branding'
  puts Lakchelink::Branding.apply!.inspect
end
