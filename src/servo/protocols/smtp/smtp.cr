module Servo
  module SMTP
    # Standard SMTP response codes
    RESPONSES = {
      211 => "System status, or system help respond",
      214 => "Help message",
      220 => "Post Office Service ready",
      221 => "Post Office Service closing transmission channel",
      250 => "Requested mail action okay, completed",
      251 => "User not local; will forward to <forward-path>",
      354 => "Start mail input; end with <CRLF>.<CRLF>",
      421 => "Post Office Service not available,",
      450 => "Requested mail action not taken: mailbox unavailable",
      451 => "Requested action aborted: error in processing",
      452 => "Requested action not taken: insufficient system storage",
      500 => "Syntax error, command unrecognized",
      501 => "Syntax error in parameters or arguments",
      502 => "Command not implemented",
      503 => "Bad sequence of commands",
      504 => "Command parameter not implemented",
      550 => "Requested action not taken: mailbox unavailable",
      551 => "User not local; please try <forward-path>",
      552 => "Requested mail action aborted: exceeded storage allocation",
      553 => "Requested action not taken: mailbox name invalid",
      554 => "Transaction failed",
    }
  end
end
