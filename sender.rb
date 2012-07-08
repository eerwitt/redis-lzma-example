require 'eventmachine'
require 'em-hiredis'
require 'lzma'

EventMachine::run do
  @pub = EM::Hiredis.connect("redis://localhost:6379")

  @timer = EventMachine::PeriodicTimer.new(5) do
    puts "Sending message"
    @pub.publish("test", LZMA.compress("BLAH"))
  end

  trap('INT') do
    STDERR.puts "Caught INT signal cleaning up"
    @timer.cancel
    @pub.close_connection
    EventMachine::stop_event_loop
  end
end
