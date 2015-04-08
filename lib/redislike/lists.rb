require 'moneta'
require_relative 'helpers/lists'

# Module containing mixins for redis-like operations.
module RedisLike
  # Mixin containing redis-like list operations for Moneta stores.
  module Lists
    include RedisLike::Keys
    include RedisLike::Helpers::Lists

    def lpush(list, item)
      enqueue list, item, to: :head
    end

    def lpushx(list, item)
      enqueue list, item, to: :head, allow_create: false
    end

    def rpush(list, item)
      enqueue list, item, to: :tail
    end

    def rpushx(list, item)
      enqueue list, item, to: :tail, allow_create: false
    end

    def blpop(list)
      block_while_empty list
      lpop list
    end

    def lpop(list)
      dequeue list, from: :head
    end

    def rpop(list)
      dequeue list, from: :tail
    end

    def brpop(list)
      block_while_empty list
      rpop list
    end

    def rpoplpush(source, destination)
      item = rpop source
      lpush destination, item
      item
    end

    def brpoplpush(source, destination)
      block_while_empty source
      rpoplpush source, destination
    end

    def lindex(list, item)
      fetch(list, []).at item
    end

    def linsert(list, location, pivot, item)
      return 0 unless exists list
      return -1 unless lrange(list, 0, -1).include? pivot
      items = fetch list, []
      index = items.index pivot
      index += 1 if location == :before
      items.insert(index, item)
      store list, items
      llen list
    end

    def llen(list)
      fetch(list, []).length
    end

    def lrange(list, start, stop)
      fetch(list, [])[(start..stop)] || []
    end

    def lrem(list, count, item)
      case
      when count > 0
        remove_count list, count, item, from: :head
      when count < 0
        remove_count list, count.abs, item, from: :tail
      when count == 0
        remove_all list, item
      end
    end

    def lset(list, index, item)
      fail KeyError, 'ERR no such key' unless exists(list)
      fail IndexError, 'ERR index out of range' unless lindex(list, index)
      items = fetch list, []
      items[index] = item
      'OK' if store list, items
    end

    def ltrim(list, start, stop)
      'OK' if store list, lrange(list, start, stop)
    end
  end
end

module Moneta
  module Defaults
    include RedisLike::Lists
  end
end
