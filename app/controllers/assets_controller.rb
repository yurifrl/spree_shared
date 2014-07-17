class AssetsController < ApplicationController

  def css
    # Get contents
    @file = get_path 'stylesheets', params[:file]
    # Render
    if !@file.nil?
      render text: File.read(@file), content_type: 'text/css'
    else
      render nothing: true, status: 404
    end
  end

  def js
    # Get contents
    @file = get_path 'javascripts', params[:file]
    # Render
    if !@file.nil?
      render js: File.read(@file)
    else
      render nothing: true, status: 404
    end
  end

  def img
    content_types = {
      ".png" => "image/png",
      ".gif" => "image/gif",
      ".jpg" => "image/jpg",
      ".jpeg" => "image/jpeg"
    }
    @file = get_path 'images', params[:file]
    # Render
    if !@file.nil?
      send_file @file, type: content_types[File.extname(@file)], disposition: "inline"
    else
      render nothing: true, status: 404
    end
  end

  private

    # Get the correct path for the file
    def get_path(folder, file)
      if File.exists? File.join(tenant_path, folder, file)
        return File.join tenant_path, folder, file
      end
      nil
    end

end
