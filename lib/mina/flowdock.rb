require "mina/flowdock/version"
require "mina/flowdock/plugin"

extend Mina::Flowdock::Plugin

require "mina/flowdock/notify" # task

# Hook our task in after mina is done running
after_mina :"flowdock:notify"
