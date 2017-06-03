module Servo
  class SMTPServer < GenericServer
    def client_handler(client : TCPSocket)
      super
      session = Servo::Sessions::SMTPSession.new(client, @logger)
      mail_array = session.accept
      return unless mail_array.is_a?(Array(Servo::Mail))
      @logger.info("Got #{mail_array.size} mails")
    end
  end
end
