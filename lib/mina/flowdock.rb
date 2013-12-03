require "mina/flowdock/version"
require "mina/flowdock/plugin"

if defined?(Mina) && self.respond_to?(:mina_cleanup!)
  # supporting module for notify task
  extend Mina::Flowdock::Plugin

  # notify task
  require "mina/flowdock/notify"

  # hook notify after deploy
  after_mina :"flowdock:notify"
end
