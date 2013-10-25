require 'bundler/capistrano'

set :application, "dashboard"
set :deploy_to, "/srv/dashboard"
set :repository,  "https://github.com/chaosdorf/dashpi"
set :scm, :git
set :use_sudo, false
set :user, "dashboard"
role :web, "dashboardserver.chaosdorf.dn42"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
