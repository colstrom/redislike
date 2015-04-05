redislike
=========

For when we want Redis, but can't have nice things.

redislike adds backend-independent support for redis-like list operations to any Moneta datastore.

Supported Operations
--------------------
* LINDEX
* LINSERT
* LLEN
* LPOP
* LPUSH
* LPUSHX
* LRANGE
* LREM
* LSET
* LTRIM
* RPOP
* RPOPLPUSH
* RPUSH
* RPUSHX

Missing
-------
* BLPOP
* BRPOP
* BRPOPLPUSH

Other Supported Operations
--------------------------
* EXISTS

Installation
------------

```gem install redislike```

or in your Gemfile

```gem 'redislike'```

Example
-----

```
require 'redislike'
datastore = Moneta.new :Memory, expires: true

datastore.lpush 'pending', 'foo'
datastore.rpoplpush 'pending', 'active'
puts datastore.lrange 'active', 0, -1
```

Should return ```['foo']```

Motivation
----------

Redis may be my favourite data store, for a number of reasons that have nothing to do with this gem. It's also not a silver bullet. Like many tools, used in the right context, it excels. Out of its element, it adds complexity and overhead (when compared to using a tool better suited to that problem domain).

Then there's Moneta, a lovely gem that provides a unified API to an impressive range of backends for key/value storage. This allows low-effort integration with whatever data store you already have. The consistency also enables trivial swapping of backends as the evolution of an application guides requirements, without rewriting much of anything.

To achive this consistency, Moneta omits support for backend-specfic features. One of those that I often want is the (B)RPOPLPUSH list operation from Redis. This takes an item from the tail of one list, and puts it at the head of another list.

Rather than depending on a Redis backend for Moneta, and passing these operations through to it, I built redis-like queue operations on top of Moneta. Once those were in place, it seemed reasonable to continue and build the rest.

At this point, some sort of scope began to take shape. The methods were restructured to align with those provided by Redis, and tests were written to guide this process.

**TL;DR: I wanted RPOPLPUSH in Moneta, didn't define scope boundaries and accidentally reimplemented (some of) Redis.**

Dependencies
------------
* Moneta

What's up with the tests?
-------------------------

Alright, so the tests are a bit unconventional, in the sense that you need a working redis server to actually run the tests for a gem with the stated intent of not requiring a redis server.

These tests that redislike is in fact, redis-like. These work by executing the same instructions against redis, and an in-memory instance of redislike, and asserting that the results should be the same.
