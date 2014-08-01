#Makes image part db specific
module Spree
  Image.class_eval do
    before_save :confirm_public_folder

    def confirm_public_folder
      SpreeSharedHelper.confirm_public_alias_exists
    end

    def self.change_paths(database)
      if Rails.env == 'production'
        Image.attachment_definitions[:attachment][:path] = "/home/ec2-user/yebo_tenants/#{database}/public/products/:id/:style/:basename.:extension"
      else
        Image.attachment_definitions[:attachment][:path] = ":rails_root/app/tenants/#{database}/public/products/:id/:style/:basename.:extension"
      end
      Image.attachment_definitions[:attachment][:url]  = "/yebo/#{database}/products/:id/:style/:basename.:extension"
    end
  end
end
