require 'timeout'

context 'BRPOPLPUSH' do
  setup do
    @db = Moneta.new :Memory
  end

  given 'an empty list' do
    should 'block' do
      assert_raises Timeout::Error do
        Timeout.timeout(0.1) { @db.brpoplpush 'test:nx', 'test:rpoplpush:b' }
      end
    end
  end

  teardown { @db.close }
end
