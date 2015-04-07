context 'LTRIM' do
  include CompatibilityTesting

  setup do
    @original = Redis.new
    @compatible = Moneta.new :Memory
    100.times { mirror :lpush, 'test:ltrim', 'foo' }
  end

  test 'when list does not exist' do
    assert_compatible :ltrim, 'test:nx', 0, 10
  end

  test 'when range is larger than list length' do
    assert_compatible :ltrim, 'test:ltrim', 0, 200
    assert_equal mirror(:lrange, 'test:ltrim', 0, -1).uniq.flatten.size, 100
  end

  teardown do
    @original.del 'test:ltrim'
    @original.disconnect!
    @compatible.close
  end
end
