context 'LINDEX' do
  include CompatibilityTesting

  setup do
    @original = Redis.new
    @compatible = Moneta.new :Memory
    mirror :lpush, 'test:lindex', 'foo'
    mirror :lpush, 'test:lindex', 'bar'
    mirror :lpush, 'test:lindex', 'baz'
  end

  test 'when list does not exist' do
    assert_compatible :lindex, 'test:nx', 1
  end

  test 'in range' do
    assert_compatible :lindex, 'test:lindex', 1
  end

  test 'out of range' do
    assert_compatible :lindex, 'test:lindex', 999
  end

  teardown do
    @original.del 'test:lindex'
    @original.disconnect!
    @compatible.close
  end
end
