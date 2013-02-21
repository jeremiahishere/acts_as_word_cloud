# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "acts_as_word_cloud"
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremiah Hemphill", "Alfredo Uribe"]
  s.date = "2013-02-21"
  s.description = "Returns values for specified methods on each object containing mixix and values from general methods specified for models that don't have the mixin; depending on 'depth' value passed in the method will also recursively return values for associated objects on each model scanned"
  s.email = "jeremiah@cloudspace.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".DS_Store",
    ".document",
    ".gitignore_new",
    ".rspec",
    "CHANGELOG",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "acts_as_word_cloud.gemspec",
    "lib/acts_as_word_cloud.rb",
    "lib/acts_as_word_cloud/config.rb",
    "lib/acts_as_word_cloud/engine.rb",
    "lib/acts_as_word_cloud/railtie.rb",
    "lib/acts_as_word_cloud/word_cloud.rb",
    "lib/generators/acts_as_word_cloud/install_generator.rb",
    "lib/generators/acts_as_word_cloud/templates/config.rb",
    "spec/acts_as_word_cloud_spec.rb",
    "spec/dummy/README.rdoc",
    "spec/dummy/Rakefile",
    "spec/dummy/app/assets/javascripts/application.js",
    "spec/dummy/app/assets/stylesheets/application.css",
    "spec/dummy/app/controllers/application_controller.rb",
    "spec/dummy/app/helpers/application_helper.rb",
    "spec/dummy/app/mailers/.gitkeep",
    "spec/dummy/app/models/.gitkeep",
    "spec/dummy/app/models/article.rb",
    "spec/dummy/app/models/article_reader.rb",
    "spec/dummy/app/models/author.rb",
    "spec/dummy/app/models/publisher.rb",
    "spec/dummy/app/models/reader.rb",
    "spec/dummy/app/views/layouts/application.html.erb",
    "spec/dummy/config.ru",
    "spec/dummy/config/application.rb",
    "spec/dummy/config/boot.rb",
    "spec/dummy/config/database.yml",
    "spec/dummy/config/environment.rb",
    "spec/dummy/config/environments/development.rb",
    "spec/dummy/config/environments/production.rb",
    "spec/dummy/config/environments/test.rb",
    "spec/dummy/config/initializers/backtrace_silencers.rb",
    "spec/dummy/config/initializers/inflections.rb",
    "spec/dummy/config/initializers/mime_types.rb",
    "spec/dummy/config/initializers/secret_token.rb",
    "spec/dummy/config/initializers/session_store.rb",
    "spec/dummy/config/initializers/wrap_parameters.rb",
    "spec/dummy/config/locales/en.yml",
    "spec/dummy/config/routes.rb",
    "spec/dummy/db/migrate/20121107162154_create_system.rb",
    "spec/dummy/db/schema.rb",
    "spec/dummy/lib/assets/.gitkeep",
    "spec/dummy/log/.gitkeep",
    "spec/dummy/public/404.html",
    "spec/dummy/public/422.html",
    "spec/dummy/public/500.html",
    "spec/dummy/public/favicon.ico",
    "spec/dummy/script/rails",
    "spec/integration_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/blueprints.rb"
  ]
  s.homepage = "http://github.com/jeremiahishere/acts_as_word_cloud"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.15"
  s.summary = "Search function for associated objects on model"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3.1.0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 0"])
      s.add_development_dependency(%q<database_cleaner>, ["~> 0.6.7"])
      s.add_development_dependency(%q<bundler>, ["~> 1.2.3"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<debugger>, [">= 0"])
    else
      s.add_dependency(%q<rails>, ["~> 3.1.0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rspec-rails>, [">= 0"])
      s.add_dependency(%q<database_cleaner>, ["~> 0.6.7"])
      s.add_dependency(%q<bundler>, ["~> 1.2.3"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<debugger>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 3.1.0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rspec-rails>, [">= 0"])
    s.add_dependency(%q<database_cleaner>, ["~> 0.6.7"])
    s.add_dependency(%q<bundler>, ["~> 1.2.3"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<debugger>, [">= 0"])
  end
end

