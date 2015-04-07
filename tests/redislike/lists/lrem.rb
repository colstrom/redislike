context 'LREM' do
  setup do
    @db = Moneta.new :Memory
  end

  given 'an empty list' do
    should 'return no items removed' do
      assert_equal 0, @db.lrem('test:nx', 0, 'foo')
    end
  end

  given 'a list with 6 items' do
    setup do
      3.times { @db.lpush 'test:lrem', 'foo' }
      3.times { @db.lpush 'test:lrem', 'bar' }
    end

    context 'when the target is present 3 times' do
      [1, -1].each do |multiplier|
        direction = multiplier > 0 ? 'head' : 'tail'
        context "when removing 9 times from #{direction}" do
          should 'remove 3 items from' do
            assert_equal 3, @db.lrem('test:lrem', 9 * multiplier, 'foo')
          end

          should 'not remove other elements' do
            @db.lrem('test:lrem', 9 * multiplier, 'foo')
            assert_equal 3, @db.lrange('test:lrem', 0, -1).count('bar')
          end

          should 'not contain the target anymore' do
            @db.lrem('test:lrem', 9 * multiplier, 'foo')
            assert !@db.lrange('test:lrem', 0, -1).include?('foo')
          end
        end

        context "when removing 2 times from #{direction}" do
          should 'remove 2 items' do
            assert_equal 2, @db.lrem('test:lrem', 2 * multiplier, 'foo')
          end

          should 'not remove other elements' do
            @db.lrem('test:lrem', 2 * multiplier, 'foo')
            assert_equal 3, @db.lrange('test:lrem', 0, -1).count('bar')
          end

          should 'have one of the target remaining' do
            @db.lrem('test:lrem', 2 * multiplier, 'foo')
            assert_equal 1, @db.lrange('test:lrem', 0, -1).count('foo')
          end
        end

        context "when removing all from #{direction}" do
          should 'remove 3 items' do
            assert_equal 3, @db.lrem('test:lrem', 0 * multiplier, 'foo')
          end

          should 'not remove other elements' do
            @db.lrem('test:lrem', 0 * multiplier, 'foo')
            assert_equal 3, @db.lrange('test:lrem', 0, -1).count('bar')
          end

          should 'not contain the target anymore' do
            @db.lrem('test:lrem', 0 * multiplier, 'foo')
            assert !@db.lrange('test:lrem', 0, -1).include?('foo')
          end
        end
      end
    end
  end

  teardown { @db.close }
end
