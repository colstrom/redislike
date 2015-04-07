context 'LPUSHX' do
  setup do
    @db = Moneta.new :Memory
  end

  given 'an empty list' do
    should 'have one item when one is pushed into it' do
      assert_equal 0, @db.lpushx('test:nx', 'foo')
    end
  end

  given 'a list with 2 items' do
    setup { 2.times { @db.lpush 'test:lpushx', 'foo' } }

    context 'pushing an item into it' do
      should 'have 3 items' do
        assert_equal 3, @db.lpushx('test:lpushx', 'foo')
      end

      should 'have that item at the head of the list' do
        @db.lpushx 'test:lpushx', 'bar'
        assert_equal 'bar', @db.lpop('test:lpushx')
      end
    end
  end

  teardown { @db.close }
end
