module Servo
  module Validation
    class RFC2822
      ADDRESS_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

      def self.valid_addr?(addr)
        ADDRESS_REGEX.match(addr)
      end
    end

    class RFC2822Exception < Exception; end
  end
end
