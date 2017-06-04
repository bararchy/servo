module Servo
  module Sessions
    class SMTPSession
      def initialize(client : TCPSocket, logger : Logger)
        @messages = [] of Servo::Mail
        @sending_data = false
        @client = client
        @logger = logger
        @current_mail = Servo::Mail.new
        @buffer = ""
      end

      def accept
        response(250)
        loop do
          break if @client.closed?
          begin
            input = @client.gets(false)
            # The first word of a line should contain the command
            command = input.to_s.split(' ', 2).first.upcase.strip
            process_command(command, input)
          rescue e : Exception
            @logger.error("Error in SMTPSession: #{e.class} #{e}")
            @logger.debug("#{e.backtrace}")
            @client.close
            break
          end
        end
        @messages
      end

      def add_mail(mail : Servo::Mail)
        @logger.info("Added mail to session")
        @logger.debug(mail.dump)
        @messages << mail
      end

      def get_mail : Array(Servo::Mail)
        @messages
      end

      def response(status : Int32)
        @client.write "#{status} #{Servo::SMTP::RESPONSES[status]}\n".to_slice
      end

      def process_command(command, full_data)
        case command.chomp(":")
        when "DATA"         then data
        when "HELO", "EHLO" then response(250)
        when "NOOP"         then response(250)
        when "MAIL"         then mail_from(full_data.to_s)
        when "QUIT"         then quit
        when "RCPT"         then rcpt_to(full_data.to_s)
        when "RSET"         then rset
        when "SUBJECT"      then subject(full_data.to_s)
        else
          if @sending_data
            append_data(full_data.to_s)
          else
            response(500)
          end
        end
      end

      # Send a greeting to client
      def greet
        response(220)
      end

      # Close connection
      def quit
        response(221)
        @client.close
      end

      def subject(full_data)
        if /^SUBJECT:/ =~ full_data.upcase
          @logger.debug("Subject request")
          @current_mail.subject = full_data.gsub(/^SUBJECT:\s*/i, "").gsub(/[\r\n]/, "")
          response(250)
        else
          response(500)
        end
      end

      # Store sender address
      def mail_from(full_data)
        if /^MAIL FROM:/ =~ full_data.upcase
          from = full_data.gsub(/^MAIL FROM:\s*/i, "").gsub(/[\r\n]/, "")
          return response(553) unless Servo::Validation::RFC2822.valid_addr?(from.gsub(/(<|>)/, ""))
          @current_mail.from = from
          response(250)
        else
          response(500)
        end
      end

      # Store recepient address
      def rcpt_to(full_data)
        if /^RCPT TO:/ =~ full_data.upcase
          to = full_data.gsub(/^RCPT TO:\s*/i, "").gsub(/[\r\n]/, "")
          return response(553) unless Servo::Validation::RFC2822.valid_addr?(to.gsub(/(<|>)/, ""))
          @current_mail.to = to
          response(250)
        else
          response(500)
        end
      end

      # Mark client sending data
      def data
        @sending_data = true
        @buffer = ""
        response(354)
      end

      # Reset current session
      def rset
        @current_mail = Servo::Mail.new
        @buffer = ""
        @sending_data = false
      end

      # Append data to incoming mail message
      #
      # full_data == "." indicates the end of the message
      def append_data(full_data : String)
        if full_data.gsub(/[\r\n]/, "") == "."
          @current_mail.data = @buffer
          response(250)
          @logger.info("Received mail from #{@current_mail.from} to #{@current_mail.to}")
          add_mail(@current_mail)
          @current_mail = Servo::Mail.new
          @buffer = ""
        else
          @buffer = @buffer + full_data
        end
      end
    end
  end
end
