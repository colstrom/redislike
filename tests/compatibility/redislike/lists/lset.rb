context 'LSET' do
  include CompatibilityTesting

  setup do
    @original = Redis.new
    @compatible = Moneta.new :Memory
    3.times { mirror :lpush, 'test:lset', 'foo' }
  end

  test 'in range' do
    assert_compatible :lset, 'test:lset', 1, 'bar'
    assert_equal mirror(:lindex, 'test:lset', 1).uniq, ['bar']
  end

  teardown do
    @original.del 'test:lset'
    @original.disconnect!
    @compatible.close
  end
end
