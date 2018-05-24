module HuntBot
  module Scheduler
    def self.run(bot, hunts)
      scheduler = Rufus::Scheduler.new

      def scheduler.on_error(job, error)
        Discordrb::LOGGER.error(error)
        error.backtrace.each { |line| Discordrb::LOGGER.error(line) }
      end

      scheduler.every('20s', overlap: false) do
        hunts.poll
      end
    end
  end
end
