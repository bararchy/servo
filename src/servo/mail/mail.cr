module Servo
  class Mail
    property :from, :to, :subject, :data

    def initialize
      @from = ""
      @to = ""
      @subject = ""
      @data = ""
    end

    def dump
      <<-EOF
      From: #{@from}
      To: #{@to}
      Subject: #{@subject}
      Body:\r\n#{@data}
      EOF
    end
  end
end
