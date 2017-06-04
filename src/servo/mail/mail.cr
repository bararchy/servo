module Servo
  class Mail
    # property :from, :to, :subject, :data

    def initialize
      @from = ""
      @to = ""
      @subject = ""
      @data = ""
    end

    def from : String
      @from
    end

    def to : String
      @to
    end

    def subject : String
      @subject
    end

    def data : String
      @data
    end

    def from=(addr : String)
      validate(addr)
      @from = addr
    end

    def to=(addr : String)
      validate(addr)
      @to = addr
    end

    def subject=(subject : String)
      @subject = subject
    end

    def data=(data : String)
      @data = data
    end

    def validate(addr : String)
      fail_valid(addr) unless Servo::Validation::RFC2822.valid_addr?(addr.gsub(/(<|>)/, ""))
    end

    def fail_valid(addr : String)
      raise Servo::Validation::RFC2822Exception.new("#{addr} is not in valid format")
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
