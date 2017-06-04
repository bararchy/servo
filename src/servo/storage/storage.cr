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
        @db.exec "insert into mail (from_addr, to_addr, subject, data) values (?, ?, ? ,?)", mail.from, mail.to, mail.subject, mail.data
      end
    end

    def get_mails : Hash(Int32, Servo::Mail)
      hash = {} of Int32 => Servo::Mail
      @db.query "SELECT id, from_addr, to_addr, subject, data FROM mail" do |rs|
        rs.each do
          mail = Servo::Mail.new
          id = rs.read(Int32)
          mail.from = rs.read(String)
          mail.to = rs.read(String)
          mail.subject = rs.read(String)
          mail.data = rs.read(String)
          hash[id] = mail
        end
      end
      hash
    end

    def delete_id(id : Int32)
      @db.exec "DELETE FROM mail WHERE id = #{id}"
    end

    def generate_tables
      @db.exec "CREATE TABLE IF NOT EXISTS mail (id mediumint AUTO_INCREMENT,
       from_addr varchar(30),
       to_addr varchar(30),
       subject varchar(30),
       data mediumtext,
       UNIQUE KEY (id))"
    end
  end
end
