# config valid only for current version of Capistrano
lock '3.10.2'

set :application, 'ffxiv-hunt-bot'
set :repo_url,    'https://github.com/mattantonelli/ffxiv-hunt-bot'
set :branch,      ENV['BRANCH_NAME'] || 'master'
set :deploy_to,   '/var/bot/hunts'
set :default_env, { path: '$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH' }

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.4.1'

namespace :deploy do
  desc 'Symlink configuration'
  after :updating, :symlink_config do
    on roles(:app) do
      execute :ln, '-s', shared_path.join('config.yml'), release_path.join('config/config.yml')
    end
  end

  desc 'Restart the bot'
  after :publishing, :restart do
    on roles(:app) do
      invoke 'deploy:stop'
      invoke 'deploy:start'
    end
  end

  desc 'Start the bot'
  task :start do
    on roles(:app) do
      within release_path do
        info 'Starting the bot'
        execute *%w(screen -d -S hunts -m bundle exec ruby run.rb)
      end
    end
  end

  desc 'Stop the bot'
  task :stop do
    on roles(:app) do
      info 'Stopping the bot'
      execute 'trap "screen -S hunts -X quit" QUIT TERM INT EXIT'
    end
  end
end
