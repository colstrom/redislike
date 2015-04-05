Gem::Specification.new do |gem|
  gem.name        = 'redislike'
  gem.version     = '0.1.0'
  gem.licenses    = 'MIT'
  gem.authors     = ['Chris Olstrom']
  gem.email       = 'chris@olstrom.com'
  gem.homepage    = 'http://colstrom.github.io/redislike/'
  gem.summary     = %Q{For when we want Redis, but can't have nice things.}
  gem.description = %Q{redislike adds backend-independent support for redis-like list operations to any Moneta datastore.}

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'moneta', '~> 0.8'

  gem.add_development_dependency 'kintama', '~> 0.1'
  gem.add_development_dependency 'simplecov', '~> 0.8'
  gem.add_development_dependency 'redis', '~> 3.2'
end
