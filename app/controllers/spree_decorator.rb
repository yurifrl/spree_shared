ApplicationController.class_eval do
  before_filter :confirm_public_folder

  def confirm_public_folder
    db_name = Apartment::Tenant.current_tenant
    public  = File.join Rails.root, 'public', 'yebo', db_name
    File.exist? public
    public_tenant = File.join Rails.root, 'app', 'tenants', db_name, 'public'
    FileUtils.mkdir_p public
    FileUtils.ln_s public, public_tenant, :force => true
  end
end