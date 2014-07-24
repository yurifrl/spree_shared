class AssetsController < ApplicationController

  def css
    @css_contents = File.read(File.join(current_asset_path, "stylesheets", params[:file]))
    render :text => @css_contents, :content_type => "text/css"
  end

  def js
    @js_contents = File.read(File.join(current_asset_path, "javascripts", params[:file]))
    render :js => @js_contents
  end

  def img
    content_types = {
      ".png" => "image/png",
      ".gif" => "image/gif",
      ".jpg" => "image/jpg",
      ".jpeg" => "image/jpeg"
    }
    img_file = File.join(current_asset_path, "images", params[:file])
    send_file img_file, type: content_types[File.extname(img_file)], disposition: "inline"
  end
end
