ApplicationController.class_eval do
  before_filter :confirm_public_folder

  def confirm_public_folder
    db_name       = Apartment::Tenant.current_tenant
    root          = File.join Rails.root
    public_global = root, 'public', 'yebo', db_name
    public_tenant = root, 'app', 'tenants', db_name, 'public'
    unless File.exist? public_global
      FileUtils.mkdir_p public_global
      FileUtils.ln_s public_global, public_tenant, :force => true
    end
  end
end