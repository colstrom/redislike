context 'LRANGE' do
  setup do
    @db = Moneta.new :Memory
  end

  given 'an empty list' do
    should 'return an empty list' do
      assert_equal [], @db.lrange('test:nx', 0, -1)
    end
  end

  given 'a list with three items in it' do
    setup do
      @db.lpush 'test:lrange', 'foo'
      @db.lpush 'test:lrange', 'bar'
      @db.lpush 'test:lrange', 'baz'
    end

    context 'a range within the list' do
      should 'return the items in that range' do
        assert_equal %w(baz bar), @db.lrange('test:lrange', 0, 1)
      end
    end

    context 'a range containing the whole list' do
      should 'return the whole list' do
        assert_equal %w(baz bar foo), @db.lrange('test:lrange', 0, -1)
      end
    end

    context 'an out of range stop' do
      should 'return the whole list' do
        assert_equal %w(baz bar foo), @db.lrange('test:lrange', 0, 9)
      end
    end

    context 'stop before stop' do
      should 'return an empty list' do
        assert_equal [], @db.lrange('test:lrange', -1, 1)
      end
    end
  end

  teardown { @db.close }
end
