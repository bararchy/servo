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

  class Configuration
    JSON.mapping(
      database: Servo::Databases
    )
  end
end
