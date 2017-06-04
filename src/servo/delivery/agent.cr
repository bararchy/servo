require "smtp"

module Servo
  module Delivery
    class Agent
      def initialize(logger : Logger, configs : Servo::Configuration)
        @store = Servo::Storage.new(logger, configs)
        @client = SMTP::Client.new(configs.mta.host)
      end

      def loop_deliver
        loop do
          mail_hash = @store.get_mails
          if mail_hash.size == 0
            sleep 1
            next
          end
          mail_hash.each do |id, mail|
            message = SMTP::Message.new
            message.from = mail.from
            message.to = mail.to
            message.subject = mail.subject
            message.body = mail.data
            @client.send message
            @store.delete_id(id)
          end
        end
      end
    end
  end
end
