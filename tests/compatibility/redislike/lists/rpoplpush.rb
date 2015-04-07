context 'RPOPLPUSH' do
  include CompatibilityTesting

  setup do
    @original = Redis.new
    @compatible = Moneta.new :Memory
    mirror :lpush, 'test:rpoplpush', 'foo'
  end

  test 'when source list does not exist' do
    assert_compatible :rpoplpush, 'test:nx', 'test:rpoplpush:a'
  end

  test 'when list exists' do
    3.times { mirror :lpush, 'test:rpoplpush:a', 'foo' }
    assert_compatible :rpoplpush, 'test:rpoplpush:a', 'test:rpoplpush:b'
  end

  teardown do
    @original.del 'test:rpoplpush:a', 'test:rpoplpush:b'
    @original.disconnect!
    @compatible.close
  end
end
