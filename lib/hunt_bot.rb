require 'rubygems'
require 'bundler/setup'
require 'json'
require 'ostruct'
require 'yaml'

Bundler.require(:default)

module HuntBot
  CONFIG = OpenStruct.new(YAML.load_file('config/config.yml'))
  HUNTS  = YAML.load_file('config/hunts.yml')

  Dir['lib/hunt_bot/*.rb'].each { |file| load file }

  bot = Discordrb::Commands::CommandBot.new(token: CONFIG.token, client_id: CONFIG.client_id, log_mode: :quiet)

  hunts = Hunts.new(bot)
  Scheduler.run(bot, hunts)

  logfile = File.open('log.txt', 'a')
  $stderr = logfile
  Discordrb::LOGGER.streams << logfile

  bot.run
end
