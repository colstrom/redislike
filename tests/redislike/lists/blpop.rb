require 'timeout'

context 'BLPOP' do
  setup do
    @db = Moneta.new :Memory
  end

  given 'an empty list' do
    should 'block' do
      assert_raises Timeout::Error do
        Timeout.timeout(0.1) { @db.blpop 'test:nx' }
      end
    end
  end

  given 'a list with two items in it' do
    setup do
      @db.lpush 'test:blpop', 'foo'
      @db.lpush 'test:blpop', 'bar'
    end

    should 'return items from the head of the list' do
      values = 2.times.map { @db.blpop 'test:blpop' }
      assert_equal ['bar', 'foo'], values
    end

    should 'block when there are no items in the list' do
      2.times { @db.blpop 'test:blpop' }

      assert_raises Timeout::Error do
        Timeout.timeout(0.1) { @db.blpop 'test:blpop' }
      end
    end      
  end

  teardown { @db.close }
end
