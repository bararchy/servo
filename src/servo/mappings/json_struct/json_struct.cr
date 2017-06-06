require "json"

module Servo
  class Databases
    JSON.mapping(
      user: String,
      host: String,
      password: String,
      db_name: String,
    )
  end

  class MTA
    JSON.mapping(
      host: String,
      port: Int32
    )
  end

  class Configuration
    JSON.mapping(
      database: Servo::Databases,
      mta: Servo::MTA
    )
  end
end
