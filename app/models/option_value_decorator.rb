#Makes image part db specific
module Spree
  OptionValue.class_eval do
    # Upload in tenants
    before_save :confirm_public_folder

    def confirm_public_folder
      SpreeSharedHelper.confirm_public_alias_exists
    end

    def self.change_paths(tenant)
      path = SpreeSharedHelper.tenants_path(tenant)

      OptionValue.attachment_definitions[:image][:path] = "#{path}/option_values/:id/:style/:basename.:extension"
      OptionValue.attachment_definitions[:image][:url]  = "/yebo/#{tenant}/option_values/:id/:style/:basename.:extension"
    end
  end
end
