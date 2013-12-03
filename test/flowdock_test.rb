require "helper"
require "mina/flowdock/version"

describe Mina::Flowdock do
  it "has a version constant" do
    version = Mina::Flowdock.const_get("VERSION")

    refute_empty version
  end
end
