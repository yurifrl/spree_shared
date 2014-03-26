module SpreeShared
  class Engine < Rails::Engine
    engine_name 'spree_shared'

    config.autoload_paths += %W(#{config.root}/lib)

    initializer "spree_shared.application_controller" do |app|
      ::ApplicationController.class_eval do

        before_filter :prepend_view_paths

        def prepend_view_paths
          if current_tenant.present?
            prepend_view_path "app/tenants/#{current_tenant}/themes/#{current_theme}/views"
          end
        end

        def current_tenant
          if request.subdomain.present?
            tenant = request.subdomain.gsub('-','_')
          else
            tenant = ""
          end
          tenant
        end

        def current_theme
          session[:theme] || "basic"
        end

        def current_asset_path
          File.join(Rails.root, 'app', 'tenants', current_tenant, 'themes', current_theme)
        end
      end
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.application.config.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
