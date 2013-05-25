require 'bundler/capistrano'

set :application, "dashpi"
set :deploy_to, "/srv/http/dashpi"
set :repository,  "https://github.com/chaosdorf/dashpi"
set :scm, :git
set :use_sudo, false
set :user, "dashpi"
role :app, "webserver.chaosdorf.dn42"
role :db, "webserver.chaosdorf.dn42", :primary => true
role :web, "webserver.chaosdorf.dn42"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
