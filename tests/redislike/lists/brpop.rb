require 'timeout'

context 'BRPOP' do
  setup do
    @db = Moneta.new :Memory
  end

  given 'an empty list' do
    should 'block' do
      assert_raises Timeout::Error do
        Timeout.timeout(0.1) { @db.brpop 'test:nx' }
      end
    end
  end

  given 'a list with two items in it' do
    setup do
      @db.lpush 'test:brpop', 'foo'
      @db.lpush 'test:brpop', 'bar'
    end

    should 'return items from the head of the list' do
      values = 2.times.map { @db.brpop 'test:brpop' }
      assert_equal ['foo', 'bar'], values
    end

    should 'block when there are no items in the list' do
      2.times { @db.brpop 'test:brpop' }

      assert_raises Timeout::Error do
        Timeout.timeout(0.1) { @db.brpop 'test:brpop' }
      end
    end      
  end

  teardown { @db.close }
end
