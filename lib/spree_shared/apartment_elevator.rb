module Apartment
  module Elevators
    # Provides a rack based db switching solution based on subdomains
    # Assumes that database name should match subdomain
    class Subdomain

      def initialize(app)
        @app = app
      end

      def call(env)
        request = ActionDispatch::Request.new(env)

        Rails.logger.error "  Requested URL: #{request.url}"
        database = subdomain(request)

        if database
          #switch database
          begin
            database.gsub! '-', '_'

            ActiveRecord::Base.establish_connection
            result = ActiveRecord::Base.execute("SELECT id from public.customers where domain = '#{database}' and status = true")

            if result.length > 0

              Apartment::Database.switch database

              Rails.logger.error "  Using database '#{database}'"

              Spree.config do |config|
                config.allow_ssl_in_production = false
              end

              #set image location
              Spree::Image.change_paths database

              #namespace cache keys
              ENV['RAILS_CACHE_ID']= database

              #reset Mail settings
              Spree::Core::MailSettings.init
            else
              raise "Client is not active"
            end
          rescue Exception => e
            Rails.logger.error "  Stopped request due to: #{e.message}"

            #fallback
            ENV['RAILS_CACHE_ID'] = ""
            Apartment::Database.switch nil
            ActiveRecord::Base.establish_connection
            return ahh_no
          end

          #continue on to rails
          @app.call(env)
        else
          ahh_no
        end
      end

      def subdomain(request)
        request.subdomain.to_s.split('.').first
      end

      def ahh_no
        [200, {"Content-type" => "text/html"}, ["Ahh No."]]
      end

    end
  end
end

