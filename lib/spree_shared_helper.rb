class SpreeSharedHelper
  def self.confirm_public_alias_exists(tenant = nil)
    if tenant.nil?
      db_name = Apartment::Tenant.current_tenant
    else
      db_name = tenant
    end
    tenant = File.join Rails.root, 'app', 'tenants', db_name, 'public'
    yebo   = File.join Rails.root, 'public', 'yebo'
    global = File.join Rails.root, 'public', 'yebo', db_name

    FileUtils.mkdir_p tenant unless File.exist? tenant
    FileUtils.mkdir_p yebo unless File.exist? yebo
    FileUtils.ln_s tenant, global, :force => true unless File.exist? global
  end
end