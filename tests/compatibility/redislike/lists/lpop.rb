context 'LPOP' do
  include CompatibilityTesting

  setup do
    @original = Redis.new
    @compatible = Moneta.new :Memory
    mirror :lpush, 'test:lpop', 'foo'
  end

  test 'when list does not exist' do
    assert_compatible :lpop, 'test:nx'
  end

  test 'when list exists' do
    mirror :lpush, 'test:lpop', 'foo'
    assert_compatible :lpop, 'test:nx'
  end

  teardown do
    @original.del 'test:lpop'
    @original.disconnect!
    @compatible.close
  end
end
