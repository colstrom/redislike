context 'LINSERT' do
  setup do
    @db = Moneta.new :Memory
    @db.lpush 'test:linsert', 'foo'
  end

  context 'inserting before a pivot value' do
    test 'when list does not exist' do
      assert_equal 0, @db.linsert('test:nx', :before, 'foo', 'bar')
    end

    test 'when pivot is present' do
      assert_equal 2, @db.linsert('test:linsert', :before, 'foo', 'bar')
    end

    test 'when pivot is not present' do
      assert_equal -1, @db.linsert('test:linsert', :before, 'baz', 'bar')
    end
  end

  context 'inserting after a pivot' do
    test 'when list does not exist' do
      assert_equal 0, @db.linsert('test:nx', :after, 'foo', 'bar')
    end

    test 'when pivot is present' do
      assert_equal 2, @db.linsert('test:linsert', :after, 'foo', 'bar')
    end

    test 'when pivot is not present' do
      assert_equal -1, @db.linsert('test:linsert', :after, 'baz', 'bar')
    end
  end

  teardown { @db.close }
end
