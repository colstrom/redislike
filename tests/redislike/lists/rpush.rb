context 'RPUSH' do
  setup do
    @db = Moneta.new :Memory
  end

  given 'an empty list' do
    should 'have one item when one is pushed into it' do
      assert_equal 1, @db.rpush('test:nx', 'foo')
    end
  end

  given 'a list with 2 items' do
    setup { 2.times { @db.lpush 'test:rpush', 'foo' } }

    context 'pushing an item into it' do
      should 'have 3 items' do
        assert_equal 3, @db.rpush('test:rpush', 'foo')
      end

      should 'have that item at the tail of the list' do
        @db.rpush 'test:rpush', 'bar'
        assert_equal 'bar', @db.rpop('test:rpush')
      end
    end
  end

  teardown { @db.close }
end
