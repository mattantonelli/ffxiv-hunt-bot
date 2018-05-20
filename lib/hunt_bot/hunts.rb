module HuntBot
  class Hunts
    HUNTS_URL = "https://xivhunt.net/api/worlds/#{CONFIG.world_id}"

    def initialize(bot)
      @bot = bot
      poll(true)
    end

    def poll(skip_report = false)
      puts "#{Time.now} - Checking for hunts..."
      hunts = JSON.parse(RestClient.get(HUNTS_URL), symbolize_names: true)[:hunts]
      hunts.each do |hunt|
        id, alive = hunt.values_at(:id, :lastAlive)

        if !Redis.get(id) && alive
          # The hunt has been spawned
          send_alive(HUNTS[id], hunt[:lastReported])
          Redis.set(id, 1)
        elsif Redis.get(id) && !alive
          # The hunt has been killed
          send_dead(HUNTS[id], hunt[:lastReported]) unless skip_report
          Redis.del(id)
        end
      end
    end

    private
    def send_alive(hunt, time)
      unless hunt['rank'] == 'B'
        puts "Hunt found: #{hunt['name']} (#{hunt['rank']} in #{hunt['zone']})"
        @bot.channel(CONFIG.channel_id).send_embed do |embed|
          embed.colour = 8437247
          embed.description = "**#{hunt['name']} (#{hunt['rank']} Rank)** spotted in **#{hunt['zone']}**"
          embed.timestamp = Time.parse(time)
        end
      end
    end

    def send_dead(hunt, time)
      unless hunt['rank'] == 'B'
        puts "Hunt killed: #{hunt['name']} (#{hunt['rank']} in #{hunt['zone']})"
        @bot.channel(CONFIG.channel_id).send_embed do |embed|
          embed.colour = 14366791
          embed.description = "**#{hunt['name']} (#{hunt['rank']} Rank)** killed in **#{hunt['zone']}**"
          embed.timestamp = Time.parse(time)
        end
      end
    end
  end
end
