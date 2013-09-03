# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mysql-statsd/version'

Gem::Specification.new do |gem|
  gem.name          = "mysql-statsd"
  gem.version       = Mysql::Statsd::VERSION
  gem.authors       = ["Diego Carrion"]
  gem.email         = ["dc.rec1@gmail.com"]
  gem.description   = %q{Picks data from MySQL and sends it to StatsD}
  gem.summary       = %q{Picks data from MySQL and sends it to StatsD}
  gem.homepage      = ""

  gem.add_development_dependency "rspec"

  gem.add_dependency "mysql2"
  gem.add_dependency "statsd-ruby"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
