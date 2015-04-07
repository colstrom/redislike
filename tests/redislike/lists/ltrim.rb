context 'LTRIM' do
  setup do
    @db = Moneta.new :Memory
  end

  given 'an empty list' do
    should 'return success' do
      assert_equal 'OK', @db.ltrim('test:nx', 0, 99)
    end
  end

  given 'a list with 100 items' do
    setup do
      50.times { @db.lpush 'test:ltrim', 'foo' }
      50.times { @db.lpush 'test:ltrim', 'bar' }
    end

    context 'stop beyond list length' do
      should 'not truncate the list' do
        assert_equal 'OK', @db.ltrim('test:ltrim', 0, 200)
        assert_equal 100, @db.lrange('test:ltrim', 0, -1).length
      end
    end

    context 'when stop is positive' do
      setup { @db.ltrim('test:ltrim', 0, 49) }

      should 'contain items within the range' do
        assert @db.lrange('test:ltrim', 0, -1).include?('bar')
      end

      should 'not contain items outside the range' do
        assert !@db.lrange('test:ltrim', 0, -1).include?('foo')
      end
    end

    context 'when stop is negative' do
      setup { @db.ltrim('test:ltrim', -50, -1) }

      should 'contain items within the range' do
        assert !@db.lrange('test:ltrim', 0, -1).include?('bar')
      end

      should 'not contain items outside the range' do
        assert @db.lrange('test:ltrim', 0, -1).include?('foo')
      end
    end
  end

  teardown { @db.close }
end
