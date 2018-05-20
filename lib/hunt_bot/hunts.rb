module HuntBot
  class Hunts
    HUNTS_URL = "https://xivhunt.net/api/worlds/#{CONFIG.world_id}".freeze
    ALIVE_COLOR = 8437247.freeze
    DEAD_COLOR = 14366791.freeze

    def initialize(bot)
      @bot = bot
      poll(true)
    end

    def poll(skip_report = false)
      hunts = JSON.parse(RestClient.get(HUNTS_URL), symbolize_names: true)[:hunts]
      hunts.each do |hunt|
        id, alive = hunt.values_at(:id, :lastAlive)
        data = HUNTS[id]

        next if data['rank'] == 'B'

        if !Redis.get(id) && alive
          # The hunt has been spotted
          send_alive(data, hunt[:lastReported]) unless skip_report
          Redis.set(id, 1)
        elsif Redis.get(id) && !alive
          # The hunt has been killed
          send_dead(data, hunt[:lastReported]) unless skip_report
          Redis.del(id)
        end
      end
    end

    private
    def send_alive(hunt, time)
      send_message(hunt['name'], hunt['rank'], hunt['zone'], time, 'spotted', ALIVE_COLOR)
    end

    def send_dead(hunt, time)
      send_message(hunt['name'], hunt['rank'], hunt['zone'], time, 'killed', DEAD_COLOR)
    end

    def send_message(name, rank, zone, time, status, color)
      embed = Discordrb::Webhooks::Embed.new(color: color,
                                             description: "**#{name}** #{status} in **#{zone}**",
                                             timestamp: Time.parse(time))

      case rank
      when 'S'
        channels = CONFIG.s_rank_channel_ids
      when 'A'
        channels = CONFIG.a_rank_channel_ids
      end

      channels.each { |id| @bot.channel(id)&.send_embed('', embed) }
    end
  end
end
