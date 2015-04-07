context 'LPUSH' do
  include CompatibilityTesting

  setup do
    @original = Redis.new
    @compatible = Moneta.new :Memory
    mirror :lpush, 'test:lpush', 'foo'
  end

  test 'when list does not exist' do
    assert_compatible :lpush, 'test:nx', 'foo'
  end

  test 'when list has items already' do
    assert_compatible :lpush, 'test:lpush', 'foo'
  end

  teardown do
    @original.del 'test:lpush', 'test:nx'
    @original.disconnect!
    @compatible.close
  end
end
