module CompatibilityTesting
  def mirror(method, *arguments)
    original = @original.method(method).call(*arguments)
    compatible = @compatible.method(method).call(*arguments)
    [original, compatible]
  end

  def assert_compatible(method, *arguments)
    assert_equal(*mirror(method, *arguments))
  end
end
