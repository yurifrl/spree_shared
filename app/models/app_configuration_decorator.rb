# Add Spree Shared Options
Spree::AppConfiguration.class_eval do
  preference :theme, :string, default: 'basic'
end
