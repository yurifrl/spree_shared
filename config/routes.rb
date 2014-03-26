Rails.application.routes.draw do
  get "css_client", :to => "assets#css", :as => :css_client
  get "js_client", :to => "assets#js", :as => :js_client
  get "img_client", :to => "assets#img", :as => :img_client
end
