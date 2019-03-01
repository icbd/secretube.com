# config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'

set :application, 'secretube.org'
set :repo_url, 'git@github.com:icbd/secretube.org.git'

set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system]

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, ENV['branch'] || 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/web/www/#{fetch :application}"
set :ssh_options, forward_agent: true

# Default value for :format is :airbrussh.
set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# puma config
set :puma_bind, 'tcp://0.0.0.0:3030'
set :puma_preload_app, true
set :puma_prune_bundler, true
set :puma_tag, fetch(:application)
set :puma_worker_timeout, 30
set :puma_init_active_record, true
set :puma_rolling_restart, true
set :puma_rolling_wait, 15
set :puma_rolling_groups, 1

# nginx config
set :nginx_sites_available_path, '/etc/nginx/sites-available'
set :nginx_sites_enabled_path, '/etc/nginx/sites-enabled'

# secret config
envs = YAML.load_file(File.expand_path('./secret.yml', __dir__))
key_values = envs[fetch(:stage).to_s]
set :default_env, key_values if key_values.is_a?(Hash)
