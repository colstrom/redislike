context 'LREM' do
  include CompatibilityTesting

  setup do
    @original = Redis.new
    @compatible = Moneta.new :Memory
    3.times { mirror :lpush, 'test:lrem', 'foo' }
  end

  test 'when list does not exist' do
    assert_compatible :lrem, 'test:nx', 0, 'foo'
  end

  test 'all items (present)' do
    assert_compatible :lrem, 'test:lrem', 0, 'foo'
  end

  test 'all items (when not present)' do
    assert_compatible :lrem, 'test:lrem', 0, 'bar'
  end

  test 'one from head (present)' do
    assert_compatible :lrem, 'test:lrem', 1, 'foo'
  end

  test 'one from head (when not present)' do
    assert_compatible :lrem, 'test:lrem', 1, 'bar'
  end

  test 'more than exists from head (present)' do
    assert_compatible :lrem, 'test:lrem', 9, 'foo'
  end

  test 'more than exists from head (when not present)' do
    assert_compatible :lrem, 'test:lrem', 9, 'bar'
  end

  test 'one from tail (present)' do
    assert_compatible :lrem, 'test:lrem', -1, 'foo'
  end

  test 'one from tail (when not present)' do
    assert_compatible :lrem, 'test:lrem', -1, 'bar'
  end

  test 'more than exists from tail (present)' do
    assert_compatible :lrem, 'test:lrem', -9, 'foo'
  end

  test 'more than exists from tail (when not present)' do
    assert_compatible :lrem, 'test:lrem', -9, 'bar'
  end

  teardown do
    @original.del 'test:lrem'
    @original.disconnect!
    @compatible.close
  end
end
