namespace :spree_shared do
  desc "Bootstraps single database."
  task :bootstrap, [:db_name,:admin_email,:admin_password,:drop_schema_if_exists] => [:environment] do |t, args|
    if args[:db_name].blank?
      puts %q{You must supply db_name, with "rake spree_shared:bootstrap['the_db_name']"}
    else
      db_name = args[:db_name]

      drop_schema = args[:drop_schema_if_exists] || false

      #convert name to postgres friendly name
      db_name.gsub!('-','_')

      #create the database
      puts "Creating database: #{db_name}"

      config = YAML::load(File.open('config/database.yml'))

      env = ENV["RAILS_ENV"] || "development"

      Apartment.configure do |config|
        config.tenant_names = []
      end

      begin
        ActiveRecord::Base.establish_connection(config[env]) #make sure we're talkin' to db
        if !drop_schema
          schema = ActiveRecord::Base.connection.execute("SELECT schema_name FROM information_schema.schemata WHERE schema_name = '#{db_name}'")
          if schema.ntuples > 0
            raise "Schema #{db_name} already exists. No action will be taken."
          end
        else
          ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS #{db_name} CASCADE")
        end
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
          password =  args[:admin_password]
          email =  args[:admin_email]

          unless Spree::User.find_by_email(email)
            admin = Spree::User.create(:password => password,
                                :password_confirmation => password,
                                :email => email,
                                :login => email)
            role = Spree::Role.find_or_create_by_name "admin"
            admin.spree_roles << role
            admin.save
          end
        end

        puts "Bootstrap completed successfully"

      end
    end

  end

  desc "Load sample into database"
  task :load_sample, [:db_name] => [:environment] do |t,args|
    if args[:db_name].blank?
      puts %q{You must supply db_name, with "rake spree_shared:load_sample['the_db_name']"}
    else
      db_name = args[:db_name]
      #convert name to postgres friendly name
      db_name.gsub!('-','_')

      Apartment.configure do |config|
        config.tenant_names = []
      end

      Apartment::Database.process(db_name) do
        Spree::Image.change_paths db_name
        Rake::Task["spree_sample:load"].invoke
      end

      Apartment::Database.process('public') do
        ActiveRecord::Base.connection.execute()
      end
    end
  end

  desc "Remove a store"
  task :remove, [:db_name] => [:environment] do |t,args|
    if args[:db_name].blank?
      puts %q{You must supply db_name, with "rake spree_shared:remove['the_db_name']"}
    else
      db_name = args[:db_name]
      #convert name to postgres friendly name
      db_name.gsub!('-','_')

      Apartment.configure do |config|
        config.tenant_names = []
      end

      config = YAML::load(File.open('config/database.yml'))
      env = ENV["RAILS_ENV"] || "development"

      if ENV['SKIP_NAG'] or ENV['OVERWRITE'].to_s.downcase == 'true' or agree("This task will completely destroy any data in the database, public and tenant directories concerning to this store. Are you sure you want to \ncontinue? [y/n] ")
        ActiveRecord::Base.establish_connection(config[env]) #make sure we're talkin' to db
        ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS #{db_name} CASCADE")
        ActiveRecord::Base.connection.execute("DELETE FROM public.customers where database = '#{db_name}'")
        templates_base_path = File.join Rails.root, 'app', 'tenants', db_name
        FileUtils.rm_r templates_base_path
        public_path = File.join Rails.root, 'public', 'spree', db_name
        FileUtils.rm_r public_path
      else
        say "Task cancelled."
        exit
      end
    end
  end
end
