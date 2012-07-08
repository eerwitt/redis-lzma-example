require 'eventmachine'
require 'em-hiredis'
require 'lzma'

STDOUT.sync = true

EventMachine::run do
  @receiver = EM::Hiredis.connect("redis://localhost:6379")
  @receiver.subscribe "test_channel"

  @receiver.on(:message) do |channel, message|
    puts LZMA.decompress(message)
  end

  trap 'INT' do
    @receiver.close_connection
    EventMachine::stop_event_loop
  end
end
