context 'LINDEX' do
  setup do
    @db = Moneta.new :Memory
    @db.lpush 'test:lindex', 'foo'
    @db.lpush 'test:lindex', 'bar'
    @db.lpush 'test:lindex', 'baz'
  end

  test 'when list does not exist' do
    assert_equal nil, @db.lindex('test:nx', 1)
  end

  context 'when list exists' do
    test 'index in range' do
      assert_equal 'bar', @db.lindex('test:lindex', 1)
    end

    test 'index out of range' do
      assert_equal nil, @db.lindex('test:lindex', 999)
    end
  end

  teardown { @db.close }
end
