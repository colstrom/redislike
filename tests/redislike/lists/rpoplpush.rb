context 'RPOPLPUSH' do
  setup do
    @db = Moneta.new :Memory
  end

  given 'an empty list' do
    should 'return nothing' do
      assert_nil @db.rpoplpush 'test:nx', 'test:rpoplpush:b'
    end
  end

  given 'a list with two items' do
    setup do
      @db.lpush 'test:rpoplpush:a', 'foo'
      @db.lpush 'test:rpoplpush:a', 'bar'
    end

    should 'return the item at the tail of the list' do
      assert_equal 'foo', @db.rpoplpush('test:rpoplpush:a', 'test:rpoplpush:b')
    end

    context 'an item has been moved' do
      setup do
        @db.rpoplpush 'test:rpoplpush:a', 'test:rpoplpush:b'
      end

      should 'be removed from the source list' do
        assert !@db.lrange('test:rpoplpush:a', 0, -1).include?('foo')
      end

      should 'end up in the destination list' do
        assert @db.lrange('test:rpoplpush:b', 0, -1).include?('foo')
      end
    end
  end

  teardown { @db.close }
end
