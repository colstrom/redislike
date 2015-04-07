context 'RPUSH' do
  include CompatibilityTesting

  setup do
    @original = Redis.new
    @compatible = Moneta.new :Memory
    mirror :lpush, 'test:rpush', 'foo'
  end

  test 'when list does not exist' do
    assert_compatible :rpush, 'test:nx', 'foo'
  end

  test 'when list has items already' do
    mirror :lpush, 'test:rpush', 'foo'
    assert_compatible :rpush, 'test:rpush', 'foo'
  end

  teardown do
    @original.del 'test:rpush', 'test:nx'
    @original.disconnect!
    @compatible.close
  end
end
