require "./servo/**"
require "logger"

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG
server = Servo::SMTPServer.new(25, logger)
server.serve
