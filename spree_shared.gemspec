# -*- encoding: utf-8 -*-
# stub: spree_shared 0.9.0 ruby lib

Gem::Specification.new do |s|
  s.name = "spree_shared"
  s.version = "0.9.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Brian D. Quinn"]
  s.date = "2014-03-21"
  s.description = "Adds multi-tenancy to a Spree application using the Apartment gem."
  s.email = "brian@spreecommerce.com"
  s.files = [".gitignore", ".rspec", "Gemfile", "LICENSE", "README.md", "Rakefile", "Versionfile", "app/models/image_decorator.rb", "app/overrides/change_public_file_path.rb", "app/overrides/replace_layout_scripts.rb", "lib/spree_shared.rb", "lib/spree_shared/apartment_elevator.rb", "lib/spree_shared/engine.rb", "lib/spree_shared/spree_preferences_extensions.rb", "lib/tasks/db.rake", "license.md", "script/rails", "spec/spec_helper.rb", "spree_shared.gemspec"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.requirements = ["none"]
  s.rubygems_version = "2.2.2"
  s.summary = "Adds multi-tenancy to a Spree application."
  s.test_files = ["spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<spree_core>, ["~> 2.1"])
      s.add_runtime_dependency(%q<apartment>, [">= 0.24.0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 0"])
    else
      s.add_dependency(%q<spree_core>, ["~> 2.1"])
      s.add_dependency(%q<apartment>, [">= 0.24.0"])
      s.add_dependency(%q<rspec-rails>, [">= 0"])
    end
  else
    s.add_dependency(%q<spree_core>, ["~> 2.1"])
    s.add_dependency(%q<apartment>, [">= 0.24.0"])
    s.add_dependency(%q<rspec-rails>, [">= 0"])
  end
end
