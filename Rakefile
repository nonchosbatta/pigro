#! /usr/bin/env ruby
require 'rake'

task :default => [ :test, :run ]

task :test do
  File.delete 'db/spec.db' if File.exists? 'db/spec.db'
  FileUtils.cd 'spec' do
    sh 'rspec user_spec.rb --backtrace --color --format doc'
    sh 'rspec show_spec.rb --backtrace --color --format doc'
    sh 'rspec api_spec.rb  --backtrace --color --format doc'
  end
  File.delete 'db/spec.db' if File.exists? 'db/spec.db'
end

task :run, :port do |t, args|
  sh "thin -R config.ru -p #{args[:port] || 4567} start"
end