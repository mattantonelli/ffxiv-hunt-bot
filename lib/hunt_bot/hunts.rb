module HuntBot
  class Hunts
    HUNTS_BASE_URL = 'https://xivhunt.net/home/HuntTablePartial'.freeze
    ALIVE_COLOR = 8437247.freeze
    DEAD_COLOR = 14366791.freeze

    def initialize(bot)
      @bot = bot
      poll(true)
    end

    def poll(skip_report = false)
      WORLDS.each do |world, id|
        doc = Nokogiri::HTML(open("#{HUNTS_BASE_URL}/#{id}"))
        CONFIG.regions.each do |region|
          region_top = doc.at_css("h4:contains('#{region}')")
          first_zone_name = region_top.next_element.text.strip

          hunts = region_top.parent.parent.css('ul:first li').map do |hunt|
            hunt_data(hunt, world, first_zone_name)
          end

          region_top.parent.parent.css('ul:not(:first)').each do |zone|
            zone_name = zone.previous_element.text.strip
            zone.css('li').each do |hunt|
              hunts << hunt_data(hunt, world, zone_name)
            end
          end

          hunts.compact.each do |hunt|
            key = hunt[:name].delete(" '")
            alive = !hunt[:position].empty?

            if !Redis.hget(world, key) && alive
              # The hunt has been spotted
              Redis.hset(world, key, 1)
              send_alive(hunt) unless skip_report
            elsif Redis.hget(world, key) && !alive
              # The hunt has been killed
              Redis.hdel(world, key)
              send_dead(hunt) unless skip_report
            end
          end
        end
      end
    end

    private
    def hunt_data(hunt, world, zone)
      text = hunt.text.strip.split(/\r\n\s+/)
      data = { world: world, zone: zone, rank: text[0], name: text[1],
               position: "(#{text[2]&.scan(/\d+\.\d+/)&.join(', ')})" || '' }
      data if data[:rank].match?(/\A(A|S)\z/)
    end

    def send_alive(hunt)
      send_message(hunt, 'spotted', ALIVE_COLOR)
    end

    def send_dead(hunt)
      send_message(hunt, 'killed', DEAD_COLOR)
    end

    def send_message(hunt, status, color)
      embed = Discordrb::Webhooks::Embed.new(color: color,
                                             description: "**#{hunt[:name]}** #{status} in **#{hunt[:zone]}** on " \
                                             "**#{hunt[:world]}**.\n#{hunt[:position]}",
                                             timestamp: Time.now)

      case hunt[:rank]
      when 'S'
        channels = CONFIG.s_rank_channel_ids
      when 'A'
        channels = CONFIG.a_rank_channel_ids
      end

      begin
        channels.each do |id|
          @last_id = id
          @bot.channel(id)&.send_embed('', embed)
        end
      rescue Discordrb::Errors::NoPermission
        Discordrb::LOGGER.warn("Missing permissions for channel #{@last_id}")
      rescue Exception => e
        Discordrb::LOGGER.error(e)
        e.backtrace.each { |line| Discordrb::LOGGER.error(line) }
      end
    end
  end
end
