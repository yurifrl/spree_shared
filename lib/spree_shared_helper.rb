class SpreeSharedHelper
  def self.confirm_public_alias_exists(tenant = nil)
    if tenant.nil?
      db_name = Apartment::Tenant.current_tenant
    else
      db_name = tenant
    end

    if Rails.env == 'production'
      tenant = "#{ENV['PATH_TENANTS']}/#{db_name}/public"
      yebo   = "#{ENV['PATH_PUBLIC']}/yebo"
      global = "#{ENV['PATH_PUBLIC']}/yebo/#{db_name}"
    else
      tenant = File.join Rails.root, 'app', 'tenants', db_name, 'public'
      yebo   = File.join Rails.root, 'public', 'yebo'
      global = File.join Rails.root, 'public', 'yebo', db_name
    end

    p '$$$$$$$$$$$$$$'
    p tenant
    p yebo
    p global
    p '$$$$$$$$$$$$$$'

    FileUtils.mkdir_p tenant unless File.exist? tenant
    FileUtils.mkdir_p yebo unless File.exist? yebo
    FileUtils.ln_s tenant, global, :force => true unless File.exist? global
  end
end