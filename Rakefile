#! /usr/bin/env ruby
require 'rake'

task default: [ :test, :run ]

task :test do
  File.delete 'db/spec.db' if File.exists? 'db/spec.db'
  %w(user_spec show_spec api_spec).each { |spec| sh "rspec spec/#{spec}.rb" }
  File.delete 'db/spec.db' if File.exists? 'db/spec.db'
end

task :run, :port do |t, args|
  sh "thin -R config.ru -p #{args[:port] || 4567} start"
end
