module RedisLike
  module Helpers
    module Lists
      def enqueue(list, item, to:, allow_create: true)
        operation = to == :head ? :unshift : :push
        items = fetch list, []
        items.method(operation).call(item)
        store list, items if allow_create || exists(list)
        llen list
      end

      def dequeue(list, from:)
        operation = from == :head ? :shift : :pop
        current = fetch list, []
        item = current.method(operation).call
        store list, current
        item
      end

      def remove_count(list, count, item, from:)
        operation = from == :tail ? :rindex : :index
        items = fetch list, []
        removed = count.times.map do
          found = items.method(operation).call(item)
          items.delete_at found if found
        end
        store list, items
        removed.compact.length
      end

      def remove_all(list, item)
        items = fetch list, []
        remove_count list, items.count(item), item, from: :head
        # remaining = items.reject { |i| i == item }
        # store list, remaining
        # items.length - remaining.length
      end
    end
  end
end
