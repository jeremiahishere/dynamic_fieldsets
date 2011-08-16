# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "dynamic_fieldsets"
  gem.homepage = "http://github.com/jeremiahishere/dynamic_fieldsets"
  gem.license = "MIT"
  gem.summary = %Q{Dynamic fieldsets for rails controllers}
  gem.description = %Q{Dynamic fieldsets for rails controllers}
  gem.email = "jeremiah@cloudspace.com"
  gem.authors = ["Jeremiah Hemphill", "Ethan Pemble"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new

# hudson ci
require 'ci/reporter/rake/rspec'
namespace :hudson do
  def report_path
    "spec/reports/"
  end

  task :report_setup do
    rm_rf report_path
    mkdir_p report_path
  end

  # hudson cucumber rake task
  Cucumber::Rake::Task.new(:cucumber, "Run cucumber with hudson output") do |t|
    t.cucumber_opts = %{spec/dummy/features --format junit --out #{report_path}}
  end
end

#general cucumber rake tasks
require 'cucumber/rake/task'
namespace :cucumber do
  Cucumber::Rake::Task.new(:all, 'run features that should pass') do |t|
    t.cucumber_opts = "spec/dummy/features --format progress"
  end
  Cucumber::Rake::Task.new(:no_js, 'run features that should pass') do |t|
    t.cucumber_opts = "spec/dummy/features --format progress --tags ~@javascript"
  end

  task :setup_js_with_vnc4server do
    puts "Cucumber test with vnc4server"
    ENV['DISPLAY'] = ":99"
    %x{vncserver :99 2>/dev/null >/dev/null &}
    %x{DISPLAY=:99 firefox 2>/dev/null >/dev/null &}
  end

  task :kill_js do
    puts "Killing vnc, xvfb, and ff processes"
    %x{killall Xvnc4}
    %x{killall Xvfb}
    %x{killall firefox}
  end
end
task :cucumber => ['cucumber:setup_js_with_vnc4server', 'cucumber:all', 'cucumber:kill_js']
