# config valid only for current version of Capistrano
lock '3.7.1'

set :application, 'dynamic_dns'
set :repo_url, 'git@github.com:chapmajs/dynamic_dns.git'
set :deploy_to, '/home/services/dynamic_dns'
set :keep_releases, 2
