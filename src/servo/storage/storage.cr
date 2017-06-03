require "db"
require "mysql"

module Servo
  class Storage
    def initialize(logger : Logger, configs : Servo::Configuration)
      @logger = logger
      db_user = configs.database.user
      db_host = configs.database.host
      db_pass = configs.database.password
      db_name = configs.database.db_name
      @logger.debug("Connecting via: mysql://#{db_user}:#{db_pass}@#{db_host}/#{db_name}")
      @db = DB.connect("mysql://#{db_user}:#{db_pass}@#{db_host}/#{db_name}").as DB::Connection
      generate_tables
    end

    def process_array(array : Array(Servo::Mail))
      array.each do |mail|
        @db.exec "insert into mail values (?, ?, ?, ?)", mail.from, mail.to, mail.subject, mail.data
      end
    end

    def generate_tables
      @db.exec "create table IF NOT EXISTS mail (from varchar(30), to varchar(30), subject varchar(30), data MEDIUMTEXT(max))"
    end
  end
end
