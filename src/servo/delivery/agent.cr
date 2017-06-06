require "smtp"

module Servo
  module Delivery
    class Agent
      def initialize(logger : Logger, configs : Servo::Configuration)
        @logger = logger
        @store = Servo::Storage.new(logger, configs)
        @client = SMTP::Client.new(configs.mta.host)
      end

      def loop_deliver
        loop do
          begin
            @logger.debug("Propegating mails to send")
            mail_hash = @store.get_mails
            if mail_hash.size == 0
              sleep 1
              next
            end
            mail_hash.each do |id, mail|
              @logger.debug("Forwarding mail for: #{mail.from} to #{mail.to}")
              message = SMTP::Message.new
              message.from = SMTP::Address.new(email = mail.from)
              message.to << SMTP::Address.new(email = mail.to)
              message.subject = mail.subject
              message.body = mail.data + "\r\n\r\nSent By Servo mail server"
              @client.send message
              @store.delete_id(id)
            end
          rescue e : Exception
            @logger.error("Error preparing mail: #{e}")
          end
        end
      end
    end
  end
end
