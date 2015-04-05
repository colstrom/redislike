context 'List Operations' do
  def mirror(method, *arguments)
    original = @original.method(method).call(*arguments)
    compatible = @compatible.method(method).call(*arguments)
    [original, compatible]
  end

  def assert_compatible(method, *arguments)
    assert_equal(*mirror(method, *arguments))
  end

  setup do
    @original = Redis.new
    # @compatible = Moneta.new :Daybreak, file: '.test.db', expires: true
    @compatible = Moneta.new :Memory

    @original.del 'test', 'test:a', 'test:b', 'test:nx'
  end

  teardown do
    @original.disconnect!
    @compatible.close
  end

  context 'lindex' do
    setup do
      mirror :lpush, 'test', 'foo'
      mirror :lpush, 'test', 'bar'
    end

    test 'when list does not exist' do
      assert_compatible :lindex, 'test:nx', 1
    end

    test 'in range' do
      assert_compatible :lindex, 'test', 1
    end

    test 'out of range' do
      assert_compatible :lindex, 'test', 999
    end
  end

  context 'linsert' do
    setup do
      mirror :lpush, 'test', 'foo'
    end

    test 'when list does not exist' do
      assert_compatible :linsert, 'test:nx', :before, 'foo', 'bar'
      assert_compatible :linsert, 'test:nx', :after, 'foo', 'bar'
    end

    test 'when list contains pivot value' do
      assert_compatible :linsert, 'test', :before, 'foo', 'bar'
      assert_compatible :linsert, 'test', :after, 'foo', 'bar'
    end

    test 'when list does not contain pivot value' do
      assert_compatible :linsert, 'test', :before, 'baz', 'bar'
      assert_compatible :linsert, 'test', :after, 'baz', 'bar'
    end
  end

  context 'llen' do
    test 'when list does not exist' do
      assert_compatible :llen, 'test:nx'
    end

    test 'when list exists' do
      mirror :lpush, 'test', 'foo'
      assert_compatible :llen, 'test'
    end
  end

  context 'lpop' do
    test 'when list does not exist' do
      assert_compatible :lpop, 'test:nx'
    end

    test 'when list exists' do
      mirror :lpush, 'test', 'foo'
      assert_compatible :lpop, 'test:nx'
    end
  end

  context 'lpush' do
    test 'when list does not exist' do
      assert_compatible :lpush, 'test:nx', 'foo'
    end

    test 'when list has items already' do
      mirror :lpush, 'test', 'foo'
      assert_compatible :lpush, 'test', 'foo'
    end
  end

  context 'lpushx' do
    test 'when list does not exist' do
      assert_compatible :lpushx, 'test:nx', 'foo'
    end

    test 'when list has items already' do
      mirror :lpush, 'test', 'foo'
      assert_compatible :lpushx, 'test', 'foo'
    end
  end

  context 'lrange' do
    test 'when list does not exist' do
      assert_compatible :lrange, 'test:nx', 0, -1
    end

    test 'when list exists' do
      mirror :lpush, 'test', 'foo'
      assert_compatible :lrange, 'test', 0, -1
    end

    test 'stop beyond range' do
      mirror :lpush, 'test', 'foo'
      assert_compatible :lrange, 'test', 0, 9
    end

    test 'stop before start' do
      mirror :lpush, 'test', 'foo'
      assert_compatible :lrange, 'test', -1, 1
    end
  end

  context 'lrem' do
    setup do
      mirror :lpush, 'test', 'foo'
      mirror :lpush, 'test', 'foo'
      mirror :lpush, 'test', 'foo'
    end

    test 'when list does not exist' do
      assert_compatible :lrem, 'test:nx', 0, 'foo'
    end

    test 'all items (present)' do
      assert_compatible :lrem, 'test', 0, 'foo'
    end

    test 'all items (when not present)' do
      assert_compatible :lrem, 'test', 0, 'bar'
    end

    test 'one from head (present)' do
      assert_compatible :lrem, 'test', 1, 'foo'
    end

    test 'one from head (when not present)' do
      assert_compatible :lrem, 'test', 1, 'bar'
    end

    test 'more than exists from head (present)' do
      assert_compatible :lrem, 'test', 9, 'foo'
    end

    test 'more than exists from head (when not present)' do
      assert_compatible :lrem, 'test', 9, 'bar'
    end

    test 'one from tail (present)' do
      assert_compatible :lrem, 'test', -1, 'foo'
    end

    test 'one from tail (when not present)' do
      assert_compatible :lrem, 'test', -1, 'bar'
    end

    test 'more than exists from tail (present)' do
      assert_compatible :lrem, 'test', -9, 'foo'
    end

    test 'more than exists from tail (when not present)' do
      assert_compatible :lrem, 'test', -9, 'bar'
    end
  end

  context 'lset' do
    setup do
      mirror :lpush, 'test', 'foo'
      mirror :lpush, 'test', 'foo'
      mirror :lpush, 'test', 'foo'
    end

    test 'in range' do
      assert_compatible :lset, 'test', 1, 'bar'
      assert_equal mirror(:lindex, 'test', 1).uniq, ['bar']
    end
  end

  context 'ltrim' do
    setup do
      100.times do
        mirror :lpush, 'test', 'foo'
      end
    end

    test 'when list does not exist' do
      assert_compatible :ltrim, 'test:nx', 0, 10
    end

    test 'when range is larger than list length' do
      assert_compatible :ltrim, 'test', 0, 200
      assert_equal mirror(:lrange, 'test', 0, -1).uniq.flatten.size, 100
    end
  end

  context 'rpop' do
    test 'when list does not exist' do
      assert_compatible :rpop, 'test:nx'
    end

    test 'when list exists' do
      mirror :rpush, 'test', 'foo'
      assert_compatible :rpop, 'test:nx'
    end
  end

  context 'rpoplpush' do
    test 'when source list does not exist' do
      assert_compatible :rpoplpush, 'test:nx', 'test:b'
    end

    test 'when list exists' do
      3.times { mirror :lpush, 'test:a', 'foo' }
      assert_compatible :rpoplpush, 'test:a', 'test:b'
    end
  end

  context 'rpush' do
    test 'when list does not exist' do
      assert_compatible :rpush, 'test:nx', 'foo'
    end

    test 'when list has items already' do
      mirror :rpush, 'test', 'foo'
      assert_compatible :rpush, 'test', 'foo'
    end
  end

  context 'rpushx' do
    test 'when list does not exist' do
      assert_compatible :rpushx, 'test:nx', 'foo'
    end

    test 'when list has items already' do
      mirror :rpush, 'test', 'foo'
      assert_compatible :rpushx, 'test', 'foo'
    end
  end
end
