class SpreeSharedHelper
  def self.confirm_public_alias_exists(tenant = nil)
    if tenant.nil?
      db_name  = Apartment::Tenant.current_tenant
    else
      db_name = tenant
    end
    public_global = File.join Rails.root, 'public', 'yebo', db_name
    public_tenant = File.join Rails.root, 'app', 'tenants', db_name, 'public'

    FileUtils.mkdir_p public_tenant unless File.exist? public_tenant
    FileUtils.ln_s public_tenant, public_global, :force => true unless File.exist? public_global
    ##              #SOURCE,      #DESTINY
  end
end