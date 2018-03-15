Gem::Specification.new do |gem|
  tag = `git describe --tags --abbrev=0`.chomp

  gem.name          = 'redislike'
  gem.homepage      = 'http://colstrom.github.io/redislike/'
  gem.summary       = "For when we want Redis, but can't have nice things."
  gem.description   = 'redislike adds backend-independent support for redis-like list operations to any Moneta datastore.'

  gem.version       = "#{tag}"
  gem.licenses      = ['MIT']
  gem.authors       = ['Chris Olstrom']
  gem.email         = 'chris@olstrom.com'

  gem.files         = `git ls-files -z`.split("\x0")
  gem.test_files    = `git ls-files -z -- {test,spec,features}/*`.split("\x0")
  gem.executables   = `git ls-files -z -- bin/*`.split("\x0").map { |f| File.basename(f) }

  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'moneta', '~> 0.8', '>= 0.8.1'
end
