context 'LRANGE' do
  include CompatibilityTesting

  setup do
    @original = Redis.new
    @compatible = Moneta.new :Memory
    mirror :lpush, 'test:lrange', 'foo'
  end

  test 'when list does not exist' do
    assert_compatible :lrange, 'test:nx', 0, -1
  end

  test 'when list exists' do
    assert_compatible :lrange, 'test:lrange', 0, -1
  end

  test 'stop beyond range' do
    assert_compatible :lrange, 'test:lrange', 0, 9
  end

  test 'stop before start' do
    assert_compatible :lrange, 'test:lrange', -1, 1
  end

  teardown do
    @original.del 'test:lrange'
    @original.disconnect!
    @compatible.close
  end
end
