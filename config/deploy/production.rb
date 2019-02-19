server_list = %w[root@172.96.194.92:28897]
mysql_list = %w[root@172.96.194.92:28897]

set :rails_env, :production

role :puma_nginx, server_list
role :app, server_list
role :web, server_list
role :db,  mysql_list

set :puma_env, fetch(:rails_env)
set :puma_threads, [1, 2]

set :nginx_server_name, 'www.secretube.org secretube.org www.secretube.tk secretube.tk v1.secretube.tk'
