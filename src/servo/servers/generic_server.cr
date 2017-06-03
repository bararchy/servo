require "socket"
require "logger"

module Servo
  class GenericServer
    def initialize(port : Int32, logger : Logger)
      @logger = logger
      @port = port
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
