$LOAD_PATH.unshift(File.expand_path("./lib", __dir__))
require 'server'

server = Server.new

loop do
  server.client = server.tcpserver.accept
  server.accept_request
  server.display_to_terminal
  server.process_request
  server.close_client
  server.check_and_shutdown
end
