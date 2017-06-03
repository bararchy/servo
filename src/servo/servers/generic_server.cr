require "socket"
require "logger"

module Servo
  class GenericServer
    def initialize(port : Int32, logger : Logger, configs : Servo::Configuration)
      @logger = logger
      @port = port
      @store = Servo::Storage.new(logger, configs)
      @configs = configs
    end

    def serve
      server = TCPServer.new(@port)
      loop do
        begin
          spawn client_handler(server.accept)
        rescue e : Exception
          @logger.error("Error accepting client: #{e}")
        end
      end
    end

    def client_handler(client : TCPSocket)
      @logger.info("New client connection from #{client.remote_address}")
    end
  end
end
