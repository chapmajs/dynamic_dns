# config valid only for current version of Capistrano
lock '3.14.0'

set :application, 'dynamic_dns'
set :repo_url, 'git@github.com:chapmajs/dynamic_dns.git'
set :deploy_to, '/home/services/dynamic_dns'
set :keep_releases, 2

set :rvm_type, :user
set :rvm_ruby_version, '2.6.2@dynamic_dns'
