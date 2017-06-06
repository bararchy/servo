require "./servo/**"
require "logger"

conf = File.read("config.json")
configs = Servo::Configuration.from_json(conf)

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG
fork do
  logger.info("Starting delivery agent")
  agent = Servo::Delivery::Agent.new(logger, configs)
  agent.loop_deliver
end
server = Servo::SMTPServer.new(25, logger, configs)
server.serve
