#Makes image part db specific
module Spree
  Image.class_eval do
    before_save :confirm_public_folder

    def confirm_public_folder
      SpreeSharedHelper.confirm_public_alias_exists
    end

    def self.change_paths(database)
      Image.attachment_definitions[:attachment][:path] = ":rails_root/app/tenants/#{database}/public/products/:id/:style/:basename.:extension"
      Image.attachment_definitions[:attachment][:url]  = "/yebo/#{database}/products/:id/:style/:basename.:extension"
    end
  end
end
