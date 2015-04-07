context 'RPOP' do
  include CompatibilityTesting

  setup do
    @original = Redis.new
    @compatible = Moneta.new :Memory
    mirror :lpush, 'test:rpop', 'foo'
  end

  test 'when list does not exist' do
    assert_compatible :rpop, 'test:nx'
  end

  test 'when list exists' do
    mirror :rpush, 'test', 'foo'
    assert_compatible :rpop, 'test:rpop'
  end


  teardown do
    @original.del 'test:rpop'
    @original.disconnect!
    @compatible.close
  end
end
