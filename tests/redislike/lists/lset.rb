context 'LSET' do
  setup do
    @db = Moneta.new :Memory
  end

  given 'an empty list' do
    should 'raise an error' do
      assert_raises(KeyError) { @db.lset('test:nx', 1, 'foo') }
    end
  end

  given 'a list with three items' do
    setup { 3.times { @db.lpush 'test:lset', 'foo' } }

    context 'setting an item within range' do
      should 'return OK' do
        assert_equal 'OK', @db.lset('test:lset', 1, 'bar')
      end

      should 'overwrite the previous item' do
        @db.lset('test:lset', 1, 'bar')
        assert_equal 'bar', @db.lindex('test:lset', 1)
      end
    end

    context 'setting an item out of range' do
      should 'raise an error' do
        assert_raises(IndexError) { @db.lset('test:lset', 999, 'bar') }
      end
    end
  end

  teardown { @db.close }
end
