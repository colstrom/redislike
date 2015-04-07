context 'LPUSHX' do
  include CompatibilityTesting

  setup do
    @original = Redis.new
    @compatible = Moneta.new :Memory
    mirror :lpush, 'test:lpushx', 'foo'
  end

  test 'when list does not exist' do
    assert_compatible :lpushx, 'test:nx', 'foo'
  end

  test 'when list has items already' do
    assert_compatible :lpushx, 'test:lpushx', 'foo'
  end

  teardown do
    @original.del 'test:lpushx', 'test:nx'
    @original.disconnect!
    @compatible.close
  end
end
