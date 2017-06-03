require "./servo/**"
require "logger"

conf = File.read("config.json")
configs = Servo::Configuration.from_json(conf)

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

server = Servo::SMTPServer.new(25, logger, configs)
server.serve
