# FFXIV Hunt Bot

Discord bot for announcing hunts as they are reported on [XIV-Hunt](https://xivhunt.net/). Powered by [discordrb](https://github.com/meew0/discordrb).

## Installation

This is a private bot. You will need to create and run your own Discord app to add it to your server.

1. [Create a new Discord app](https://discordapp.com/developers/applications/me)
2. Click "Create a Bot User"
3. Insert your client ID into the following URL: `https://discordapp.com/oauth2/authorize?client_id=INSERT_CLIENT_ID_HERE&scope=bot&permissions=3072`
4. Follow the URL to add the bot to your server (requires the Manage Server permission)
5. `git clone https://github.com/mattantonelli/ffxiv-hunt-bot`
6. `cd ffxiv-hunt-bot`
7. `bundle install`
8. Set up the configuration file
    * `cp config/config.yml.example config/config.yml`
    * Updated the example values appropriately
9. `bundle exec ruby run.rb`

---

**Please consider pinning the following message in your hunt channels:**

These callouts are provided thanks to https://xivhunt.net/. If you are on PC, please consider contributing to this data by running their client: https://xivhunt.net/Client. However, please keep in mind that this third party software violates FFXIV's EULA. Please be courteous when pulling. <3

## Permissions

* Read Text Channels & See Voice Channels
* Send Messages

## Deployment

This bot is set up for [Capistrano](https://github.com/capistrano/capistrano) deployment. The deployment strategy is dependent on `rbenv` and `screen`. You can configure deployment to your own server by updating `config/deploy.rb` and `config/deploy/production.rb` appropriately.
