context 'RPOP' do
  setup do
    @db = Moneta.new :Memory
  end

  given 'an empty list' do
    should 'should return nothing' do
      assert_nil @db.rpop 'test:nx'
    end
  end

  given 'a list with two items in it' do
    setup do
      @db.lpush 'test:rpop', 'foo'
      @db.lpush 'test:rpop', 'bar'
    end

    should 'return items from the tail of the list' do
      values = 3.times.map { @db.rpop 'test:rpop' }
      assert_equal ['foo', 'bar', nil], values
    end
  end

  teardown { @db.close }
end
