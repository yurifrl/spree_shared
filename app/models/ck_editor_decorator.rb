#Makes image part db specific
module Ckeditor
  Picture.class_eval do
    # Upload in tenants
    before_save :confirm_public_folder

    def confirm_public_folder
      SpreeSharedHelper.confirm_public_alias_exists
    end

    def self.change_paths(tenant)
      path = SpreeSharedHelper.tenants_path(tenant)

      Ckeditor::Picture.attachment_definitions[:data][:path] = "#{path}/assets/:class/:id/:style/:basename.:extension"
      Ckeditor::Picture.attachment_definitions[:data][:url]  = "/yebo/#{tenant}/assets/:class/:id/:style/:basename.:extension"
    end
  end

  AttachmentFile.class_eval do
    # Upload in tenants
    before_save :confirm_public_folder

    def confirm_public_folder
      SpreeSharedHelper.confirm_public_alias_exists
    end

    def self.change_paths(tenant)
      path = SpreeSharedHelper.tenants_path(tenant)

      Ckeditor::AttachmentFile.attachment_definitions[:data][:path] = "#{path}/assets/:class/:id/:style/:basename.:extension"
      Ckeditor::AttachmentFile.attachment_definitions[:data][:url]  = "/yebo/#{tenant}/assets/:class/:id/:style/:basename.:extension"
    end
  end
end