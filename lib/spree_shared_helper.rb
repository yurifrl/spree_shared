class SpreeSharedHelper
  def self.confirm_public_alias_exists(tenant = nil)
    # export PATH_TENANTS=/home/ec2-user/yebo_tenants
    # export PATH_PUBLIC=/home/ec2-user/yebo_public
    tenant.nil? ? db_name = Apartment::Tenant.current : db_name = tenant

    tenant = self.tenants_path db_name
    yebo   = File.join self.public_path, 'yebo'
    global = File.join self.public_path, 'yebo', db_name

    FileUtils.mkdir_p tenant unless File.exist? tenant
    FileUtils.mkdir_p yebo unless File.exist? yebo
    FileUtils.ln_s tenant, global, :force => true unless File.exist? global

  end

  #ENV['PATH_TENANTS']
  def self.tenants_path(tenant)
    Rails.env == 'production' ? File.join('/', 'home', 'ec2-user', 'yebo_tenants') : File.join(Rails.root, 'app', 'tenants', tenant, 'public')
  end

  def self.public_path
    Rails.env == 'production' ? File.join('/', 'home', 'ec2-user', 'yebo_public') : File.join(Rails.root, 'public')
  end
end