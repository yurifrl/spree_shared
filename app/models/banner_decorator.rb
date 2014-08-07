#Makes image part db specific
module Spree
  Banner.class_eval do
    # Upload in tenants
    before_save :confirm_public_folder

    def confirm_public_folder
      SpreeSharedHelper.confirm_public_alias_exists
    end

    def self.change_paths(tenant)
      path = SpreeSharedHelper.tenants_path(tenant)

      Banner.attachment_definitions[:attachment][:path] = "#{path}/banners/:id/:style/:basename.:extension"
      Banner.attachment_definitions[:attachment][:url]  = "/yebo/#{tenant}/banners/:id/:style/:basename.:extension"
    end
  end
end
