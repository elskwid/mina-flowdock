require 'helper'
require 'mina/flowdock'

class TestMina::Flowdock < Minitest::Test

  def test_version
    version = Mina::Flowdock.const_get('VERSION')

    assert(!version.empty?, 'should have a VERSION constant')
  end

end
