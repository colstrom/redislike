context 'LLEN' do
  include CompatibilityTesting

  setup do
    @original = Redis.new
    @compatible = Moneta.new :Memory
    mirror :lpush, 'test:llen', 'foo'
  end

  test 'when list does not exist' do
    assert_compatible :llen, 'test:nx'
  end

  test 'when list exists' do
    mirror :lpush, 'test:llen', 'foo'
    assert_compatible :llen, 'test:llen'
  end

  teardown do
    @original.del 'test:llen'
    @original.disconnect!
    @compatible.close
  end
end
