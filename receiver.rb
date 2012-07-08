require 'eventmachine'
require 'em-hiredis'
require 'lzma'

EventMachine::run do
  @sub = EM::Hiredis.connect("redis://localhost:6379")
  @sub.subscribe "test"

  @sub.on(:message) do |channel, message|
    p [:message, channel, message]
    p message.length
    p message.class
    p LZMA.decompress(message)
  end

  trap 'INT' do
    STDERR.puts "Caught INT"
    @sub.close_connection
    EventMachine::stop_event_loop
  end
end
