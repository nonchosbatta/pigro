#!/usr/bin/env puma

directory Dir.pwd
rackup File.join Dir.pwd, 'config.ru'

pidfile File.join Dir.pwd, 'tmp', 'pids', 'puma.pid'
state_path File.join Dir.pwd, 'tmp', 'pids', 'puma.state'
stdout_redirect File.join(Dir.pwd, 'log', 'puma.access.log'), File.join(Dir.pwd, 'log', 'puma.error.log'), true

bind        'unix://' + File.join(Dir.pwd, 'tmp', 'sockets', 'pigro-puma.sock')
environment 'production'
workers     4
threads     0,4

preload_app!

on_worker_boot do
  DataObjects::Pooling.pools.each do |pool|
     pool.dispose
  end
end

