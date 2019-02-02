# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Load the SCM plugin appropriate to your project:
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

require 'capistrano/rvm'
require 'capistrano/rails'
require 'capistrano/puma'
require 'capistrano/puma/nginx'
install_plugin Capistrano::Puma
install_plugin Capistrano::Puma::Workers
install_plugin Capistrano::Puma::Nginx

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
