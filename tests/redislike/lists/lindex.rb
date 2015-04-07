context 'LINDEX' do
  setup do
    @db = Moneta.new :Memory
  end

  given 'an empty list' do
    should 'return nothing' do
      assert_equal nil, @db.lindex('test:nx', 1)
    end
  end

  given 'a list with 3 items' do
    setup do
      @db.lpush 'test:lindex', 'foo'
      @db.lpush 'test:lindex', 'bar'
      @db.lpush 'test:lindex', 'baz'
    end

    context 'a request for an index within range' do
      should 'return the item at that index' do
        assert_equal 'bar', @db.lindex('test:lindex', 1)
      end
    end

    context 'a request for an index out of range' do
      should 'return nothing' do
        assert_equal nil, @db.lindex('test:lindex', 999)
      end
    end
  end

  teardown { @db.close }
end
