namespace :spree_shared do
  desc "Bootstraps single database."
  task :bootstrap, [:db_name] => [:environment] do |t, args|
    if args[:db_name].blank?
      puts %q{You must supply db_name, with "rake spree_shared:bootstrap['the_db_name']"}
    else
      db_name = args[:db_name]

      #convert name to postgres friendly name
      db_name.gsub!('-','_')

      #create the database
      puts "Creating database: #{db_name}"

      config = YAML::load(File.open('config/database.yml'))

      env = ENV["RAILS_ENV"] || "development"

      begin
        ActiveRecord::Base.establish_connection(config[env]) #make sure we're talkin' to db
        ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS #{db_name} CASCADE")
        Apartment::Database.create db_name
      rescue Exception => e
        puts e.backtrace
      end

      puts "Creating asset directories"

      templates_base_path = File.join Rails.root, 'app', 'tenants', db_name, 'themes', 'basic'

      views = File.join templates_base_path, 'views'
      FileUtils.mkdir_p views unless File.exist? views

      images = File.join templates_base_path, 'images'
      FileUtils.mkdir_p images unless File.exist? images

      css = File.join templates_base_path, 'stylesheets'
      FileUtils.mkdir_p css unless File.exist? css
      FileUtils.touch File.join(css, "main.css")

      js = File.join templates_base_path, 'javascripts'
      FileUtils.mkdir_p js unless File.exist? js
      FileUtils.touch File.join(js, "main.js")

      #seed and sample it
      puts "Loading seed & sample data into database: #{db_name}"
      ENV['RAILS_CACHE_ID'] = db_name
      Apartment::Database.process(db_name) do
        Spree::Image.change_paths db_name

        ENV['AUTO_ACCEPT'] = 'true'
        ENV['SKIP_NAG'] = 'yes'

        Rake::Task["db:seed"].invoke

        store_name = db_name.humanize.titleize
        Spree::Config.set :site_name => store_name

        #Need to manually create admin as it's not created by default in production mode
        if Rails.env.production?
          password =  "spree123"
          email =  "spree@example.com"

          unless Spree::User.find_by_email(email)
            admin = Spree::User.create(:password => password,
                                :password_confirmation => password,
                                :email => email,
                                :login => email)
            role = Spree::Role.find_or_create_by_name "admin"
            admin.roles << role
            admin.save
          end
        end

        puts "Bootstrap completed successfully"

      end
    end

  end

end
