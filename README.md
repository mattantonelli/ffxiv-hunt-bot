# FFXIV Hunt Bot

Defunct Discord bot for announcing hunts as they are reported on XIV-Hunt. Powered by [discordrb](https://github.com/meew0/discordrb).

## NOTICE: THIS BOT IS NO LONGER FUNCTIONAL

The data source for this bot, XIV-Hunt, has been shut down. As a result, this bot will no longer function as of Jun 9, 2020. If you are in need of callouts for hunts, FATEs, etc., please consider joining the [Centurio Hunts](http://centuriohunts.com/) Discord. This repository will remain in place for posterity.

## Dependencies

* Ruby (2.4.1)
* Redis

## Installation

This is a private bot. You will need to create and run your own Discord app to add it to your server.

1. [Create a new Discord app](https://discordapp.com/developers/applications/me)
2. Click "Create a Bot User"
3. Insert your client ID into the following URL: `https://discordapp.com/oauth2/authorize?client_id=INSERT_CLIENT_ID_HERE&scope=bot&permissions=19456`
4. Follow the URL to add the bot to your server (requires the Manage Server permission)
5. `git clone https://github.com/mattantonelli/ffxiv-hunt-bot`
6. `cd ffxiv-hunt-bot`
7. `bundle install`
8. Set up the configuration file
    * `cp config/config.yml.example config/config.yml`
    * Updated the example values appropriately
9. `bundle exec ruby run.rb`

## Permissions

* Read Text Channels & See Voice Channels
* Send Messages
* Embed Links

## Deployment

This bot is set up for [Capistrano](https://github.com/capistrano/capistrano) deployment. The deployment strategy is dependent on `rbenv` and `screen`. You can configure deployment to your own server by updating `config/deploy.rb` and `config/deploy/production.rb` appropriately.
