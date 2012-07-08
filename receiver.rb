require 'eventmachine'
require 'em-hiredis'
require 'lzma'

EventMachine::run do
  @receiver = EM::Hiredis.connect("redis://localhost:6379")
  @receiver.subscribe "test"

  @receiver.on(:message) do |channel, message|
    puts LZMA.decompress(message)
  end

  trap 'INT' do
    @receiver.close_connection
    EventMachine::stop_event_loop
  end
end
