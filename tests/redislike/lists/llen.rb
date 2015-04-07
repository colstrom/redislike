context 'LLEN' do
  setup do
    @db = Moneta.new :Memory
    @db.lpush 'test:llen', 'foo'
  end

  test 'when list does not exist' do
    assert_equal 0, @db.llen('test:nx')
  end

  test 'when list exists' do
    assert_equal 1, @db.llen('test:llen')
    @db.lpush 'test:llen', 'bar'
    assert_equal 2, @db.llen('test:llen')
  end

  teardown { @db.close }
end
