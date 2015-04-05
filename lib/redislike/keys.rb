require 'moneta'

module RedisLike
  module Keys
    def exists(list)
      key? list
    end
  end
end

module Moneta
  module Defaults
    include RedisLike::Keys
  end
end
