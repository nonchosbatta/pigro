#! /usr/bin/env ruby
require 'rake'

task :default => [ :test, :run ]

task :test do
  FileUtils.cd 'spec' do
    sh 'rspec user_spec.rb    --backtrace --color --format doc'
    sh 'rspec show_spec.rb    --backtrace --color --format doc'
  end
  File.delete 'db/spec.db' if File.exists? 'db/spec.db'
end

task :run do
  sh 'thin -R config.ru -p 4567 start'
end