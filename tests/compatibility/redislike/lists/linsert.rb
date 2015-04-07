context 'LINSERT' do
  include CompatibilityTesting

  setup do
    @original = Redis.new
    @compatible = Moneta.new :Memory
    mirror :lpush, 'test:linsert', 'foo'
  end

  test 'when list does not exist' do
    assert_compatible :linsert, 'test:nx', :before, 'foo', 'bar'
    assert_compatible :linsert, 'test:nx', :after, 'foo', 'bar'
  end

  test 'when list contains pivot value' do
    assert_compatible :linsert, 'test:linsert', :before, 'foo', 'bar'
    assert_compatible :linsert, 'test:linsert', :after, 'foo', 'bar'
  end

  test 'when list does not contain pivot value' do
    assert_compatible :linsert, 'test:linsert', :before, 'baz', 'bar'
    assert_compatible :linsert, 'test:linsert', :after, 'baz', 'bar'
  end

  teardown do
    @original.del 'test:linsert', 'test:nx'
    @original.disconnect!
    @compatible.close
  end
end
