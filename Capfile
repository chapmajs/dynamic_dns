# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Use Git
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Cap3 Unicorn gem
require 'capistrano3/unicorn'

# Bundler support
require 'capistrano/bundler'

# Going to use RVM on the server
require 'capistrano/rvm'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
