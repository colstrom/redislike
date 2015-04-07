context 'LPUSH' do
  setup do
    @db = Moneta.new :Memory
  end

  given 'an empty list' do
    should 'have one item when one is pushed into it' do
      assert_equal 1, @db.lpush('test:nx', 'foo')
    end
  end

  given 'a list with 2 items' do
    setup { 2.times { @db.lpush 'test:lpush', 'foo' } }

    context 'pushing an item into it' do
      should 'have 3 items' do
        assert_equal 3, @db.lpush('test:lpush', 'foo')
      end

      should 'have that item at the head of the list' do
        @db.lpush 'test:lpush', 'bar'
        assert_equal 'bar', @db.lpop('test:lpush')
      end
    end
  end

  teardown { @db.close }
end
