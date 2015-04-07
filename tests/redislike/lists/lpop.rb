context 'LPOP' do
  setup do
    @db = Moneta.new :Memory
  end

  given 'an empty list' do
    should 'should return nothing' do
      assert_nil @db.lpop 'test:nx'
    end
  end

  given 'a list with two items in it' do
    setup do
      @db.lpush 'test:lpop', 'foo'
      @db.lpush 'test:lpop', 'bar'
    end

    should 'return items from the head of the list' do
      values = 3.times.map { @db.lpop 'test:lpop' }
      assert_equal ['bar', 'foo', nil], values 
    end
  end

  teardown { @db.close }
end
