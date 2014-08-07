ApplicationController.class_eval do

  # Helper method
  helper_method :tenant

  # View Path
  before_action do |controller|
    controller.prepend_view_path "#{tenant_path}/views"
  end

  def tenant_theme
    Spree::Config.theme
  end

  # Tenant
  def tenant
    Apartment::Tenant.current
  end

  # Tenant path
  def tenant_path
    # path = Pathname.new ENV['PWD']
    # path.join 'app', 'tenants', tenant, 'themes', tenant_theme
    File.expand_path(File.join('app', 'tenants', tenant, 'themes', tenant_theme))
  end

end
