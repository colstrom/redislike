context 'RPUSHX' do
  include CompatibilityTesting

  setup do
    @original = Redis.new
    @compatible = Moneta.new :Memory
    mirror :lpush, 'test:rpushx', 'foo'
  end

  test 'when list does not exist' do
    assert_compatible :rpushx, 'test:nx', 'foo'
  end

  test 'when list has items already' do
    mirror :lpush, 'test:rpushx', 'foo'
    assert_compatible :rpushx, 'test:rpushx', 'foo'
  end


  teardown do
    @original.del 'test:rpushx', 'test:nx'
    @original.disconnect!
    @compatible.close
  end
end
