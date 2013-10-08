require 'bundler/capistrano'
require 'capistrano_colors'
require 'capistrano-rbenv'
require 'capistrano-puma'

set :application,        'orstrings'
set :user,               'orstrings'
set :rails_env,          'production'

set :rbenv_ruby_version, '1.9.3-p448'

set :bundle_without,     [:development, :test]

set :deploy_to,          "/opt/#{user}/#{rails_env}"
set :deploy_via,         :copy
set :copy_strategy,      :export
set :repository,         '.'
set :scm,                :none

set :use_sudo,           false

#set :default_run_options, {:shell => false, :pty => true}
#set :default_run_options, {:shell => false}

role :web, 'orstrings.org'
role :app, 'orstrings.org'
role :db,  'orstrings.org', :primary => true

namespace :deploy do
  desc "Symlink database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end

  desc "Symlink mandrill.yml"
  task :symlink_mandrill, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/mandrill.yml #{release_path}/config/mandrill.yml"
  end
end

after 'deploy:restart', 'deploy:cleanup'
after 'deploy:finalize_update', 'deploy:symlink_db', 'deploy:symlink_mandrill'

