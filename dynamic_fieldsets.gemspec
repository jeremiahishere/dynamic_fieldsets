# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dynamic_fieldsets"
  s.version = "0.0.15"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremiah Hemphill", "Ethan Pemble", "John Carter"]
  s.date = "2012-01-30"
  s.description = "Dynamic fieldsets for rails controllers"
  s.email = "jeremiah@cloudspace.com"
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "CHANGELOG",
    "Gemfile",
    "Gemfile.lock",
    "MIT-LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "app/controllers/dynamic_fieldsets/fields_controller.rb",
    "app/controllers/dynamic_fieldsets/fieldset_associators_controller.rb",
    "app/controllers/dynamic_fieldsets/fieldset_children_controller.rb",
    "app/controllers/dynamic_fieldsets/fieldsets_controller.rb",
    "app/helpers/dynamic_fieldsets/fields_helper.rb",
    "app/helpers/dynamic_fieldsets/fieldset_children_helper.rb",
    "app/helpers/dynamic_fieldsets/nested_model_helper.rb",
    "app/helpers/dynamic_fieldsets_helper.rb",
    "app/models/dynamic_fieldsets/dependency.rb",
    "app/models/dynamic_fieldsets/dependency_clause.rb",
    "app/models/dynamic_fieldsets/dependency_group.rb",
    "app/models/dynamic_fieldsets/field.rb",
    "app/models/dynamic_fieldsets/field_default.rb",
    "app/models/dynamic_fieldsets/field_html_attribute.rb",
    "app/models/dynamic_fieldsets/field_option.rb",
    "app/models/dynamic_fieldsets/field_record.rb",
    "app/models/dynamic_fieldsets/fieldset.rb",
    "app/models/dynamic_fieldsets/fieldset_associator.rb",
    "app/models/dynamic_fieldsets/fieldset_child.rb",
    "app/views/dynamic_fieldsets/fields/_disable_field_form.html.erb",
    "app/views/dynamic_fieldsets/fields/_field_default_fields.html.erb",
    "app/views/dynamic_fieldsets/fields/_field_html_attribute_fields.html.erb",
    "app/views/dynamic_fieldsets/fields/_field_option_fields.html.erb",
    "app/views/dynamic_fieldsets/fields/_form.html.erb",
    "app/views/dynamic_fieldsets/fields/edit.html.erb",
    "app/views/dynamic_fieldsets/fields/index.html.erb",
    "app/views/dynamic_fieldsets/fields/new.html.erb",
    "app/views/dynamic_fieldsets/fields/show.html.erb",
    "app/views/dynamic_fieldsets/fieldset_associators/index.html.erb",
    "app/views/dynamic_fieldsets/fieldset_associators/show.html.erb",
    "app/views/dynamic_fieldsets/fieldset_children/_dependency_clause_fields.html.erb",
    "app/views/dynamic_fieldsets/fieldset_children/_dependency_fields.html.erb",
    "app/views/dynamic_fieldsets/fieldset_children/_dependency_group_fields.html.erb",
    "app/views/dynamic_fieldsets/fieldset_children/_form.html.erb",
    "app/views/dynamic_fieldsets/fieldset_children/edit.html.erb",
    "app/views/dynamic_fieldsets/fieldsets/_associate_child.html.erb",
    "app/views/dynamic_fieldsets/fieldsets/_child.html.erb",
    "app/views/dynamic_fieldsets/fieldsets/_form.html.erb",
    "app/views/dynamic_fieldsets/fieldsets/children.html.erb",
    "app/views/dynamic_fieldsets/fieldsets/edit.html.erb",
    "app/views/dynamic_fieldsets/fieldsets/index.html.erb",
    "app/views/dynamic_fieldsets/fieldsets/new.html.erb",
    "app/views/dynamic_fieldsets/fieldsets/reorder.html.erb",
    "app/views/dynamic_fieldsets/fieldsets/show.html.erb",
    "app/views/dynamic_fieldsets/shared/_javascript_watcher.html.erb",
    "app/views/dynamic_fieldsets/shared/_nested_model_javascript.html.erb",
    "config/.routes.rb.swp",
    "config/routes.rb",
    "dynamic_fieldsets.gemspec",
    "lib/dynamic_fieldsets.rb",
    "lib/dynamic_fieldsets/config.rb",
    "lib/dynamic_fieldsets/dynamic_fieldsets_in_model.rb",
    "lib/dynamic_fieldsets/engine.rb",
    "lib/dynamic_fieldsets/railtie.rb",
    "lib/generators/dynamic_fieldsets/controllers_generator.rb",
    "lib/generators/dynamic_fieldsets/install_generator.rb",
    "lib/generators/dynamic_fieldsets/templates/config.rb",
    "lib/generators/dynamic_fieldsets/templates/migrations/install_migration.rb",
    "lib/generators/dynamic_fieldsets/views_generator.rb",
    "spec/dummy/Rakefile",
    "spec/dummy/app/controllers/application_controller.rb",
    "spec/dummy/app/controllers/information_forms_controller.rb",
    "spec/dummy/app/helpers/application_helper.rb",
    "spec/dummy/app/helpers/information_forms_helper.rb",
    "spec/dummy/app/models/information_form.rb",
    "spec/dummy/app/views/information_forms/_form.html.erb",
    "spec/dummy/app/views/information_forms/dynamic_view.html.erb",
    "spec/dummy/app/views/information_forms/edit.html.erb",
    "spec/dummy/app/views/information_forms/index.html.erb",
    "spec/dummy/app/views/information_forms/new.html.erb",
    "spec/dummy/app/views/information_forms/show.html.erb",
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
    "spec/dummy/config/locales/en.yml",
    "spec/dummy/config/routes.rb",
    "spec/dummy/db/migrate/20110727210451_create_information_forms.rb",
    "spec/dummy/db/migrate/20111111154935_create_dynamic_fieldsets_tables.rb",
    "spec/dummy/db/schema.rb",
    "spec/dummy/features/field.feature",
    "spec/dummy/features/fieldset.feature",
    "spec/dummy/features/fieldset_associator.feature",
    "spec/dummy/features/fieldset_children.feature",
    "spec/dummy/features/javascript_tests.feature",
    "spec/dummy/features/step_definitions/debugging_steps.rb",
    "spec/dummy/features/step_definitions/field_steps.rb",
    "spec/dummy/features/step_definitions/fieldset_associator_steps.rb",
    "spec/dummy/features/step_definitions/fieldset_children_steps.rb",
    "spec/dummy/features/step_definitions/fieldset_steps.rb",
    "spec/dummy/features/step_definitions/javascript_steps.rb",
    "spec/dummy/features/step_definitions/web_steps.rb",
    "spec/dummy/features/support/env.rb",
    "spec/dummy/features/support/paths.rb",
    "spec/dummy/features/support/selectors.rb",
    "spec/dummy/public/404.html",
    "spec/dummy/public/422.html",
    "spec/dummy/public/500.html",
    "spec/dummy/public/favicon.ico",
    "spec/dummy/public/javascripts/application.js",
    "spec/dummy/public/javascripts/jquery-1.6.2.min.js",
    "spec/dummy/public/javascripts/jquery-ui-1.8.15.custom.min.js",
    "spec/dummy/public/javascripts/jquery-ui-nestedSortable.js",
    "spec/dummy/public/javascripts/jquery.min.js",
    "spec/dummy/public/stylesheets/.gitkeep",
    "spec/dummy/public/stylesheets/scaffold.css",
    "spec/dummy/script/rails",
    "spec/dynamic_fieldsets_helper_spec.rb",
    "spec/dynamic_fieldsets_in_model_spec.rb",
    "spec/dynamic_fieldsets_spec.rb",
    "spec/integration/navigation_spec.rb",
    "spec/models/dependency_clause_spec.rb",
    "spec/models/dependency_group_spec.rb",
    "spec/models/dependency_spec.rb",
    "spec/models/field_default_spec.rb",
    "spec/models/field_html_attribute_spec.rb",
    "spec/models/field_option_spec.rb",
    "spec/models/field_record_spec.rb",
    "spec/models/field_spec.rb",
    "spec/models/fieldset_associator_spec.rb",
    "spec/models/fieldset_child_spec.rb",
    "spec/models/fieldset_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/dependency_group_helper.rb",
    "spec/support/dependency_helper.rb",
    "spec/support/field_default_helper.rb",
    "spec/support/field_helper.rb",
    "spec/support/field_html_attribute_helper.rb",
    "spec/support/field_option_helper.rb",
    "spec/support/field_record_helper.rb",
    "spec/support/fieldset_associator_helper.rb",
    "spec/support/fieldset_child_helper.rb",
    "spec/support/fieldset_helper.rb"
  ]
  s.homepage = "http://github.com/jeremiahishere/dynamic_fieldsets"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.15"
  s.summary = "Dynamic fieldsets for rails controllers"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["= 3.0.7"])
      s.add_development_dependency(%q<capybara>, [">= 0.4.0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<ruby-debug19>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.6.1"])
      s.add_development_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
      s.add_development_dependency(%q<cucumber-rails>, [">= 0"])
      s.add_development_dependency(%q<database_cleaner>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.3"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<ci_reporter>, [">= 0"])
    else
      s.add_dependency(%q<rails>, ["= 3.0.7"])
      s.add_dependency(%q<capybara>, [">= 0.4.0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<ruby-debug19>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.6.1"])
      s.add_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<cucumber-rails>, [">= 0"])
      s.add_dependency(%q<database_cleaner>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.3"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<ci_reporter>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, ["= 3.0.7"])
    s.add_dependency(%q<capybara>, [">= 0.4.0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<ruby-debug19>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.6.1"])
    s.add_dependency(%q<yard>, ["~> 0.6.0"])
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<cucumber-rails>, [">= 0"])
    s.add_dependency(%q<database_cleaner>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.3"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<ci_reporter>, [">= 0"])
  end
end

