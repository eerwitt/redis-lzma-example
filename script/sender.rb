require 'eventmachine'
require 'em-hiredis'
require 'base64'
require 'lzma'

STDOUT.sync = true

EventMachine::run do
  @publisher = EM::Hiredis.connect("redis://localhost:6379")

  @timer = EventMachine::PeriodicTimer.new(5) do
    message = "a test messge to send between the two"
    puts "Sending message: #{message}"
    @publisher.publish("test_channel", Base64.b64encode(LZMA.compress(message)))
  end

  trap('INT') do
    @timer.cancel
    @publisher.close_connection
    EventMachine::stop_event_loop
  end
end
