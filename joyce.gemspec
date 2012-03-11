# -*- encoding: utf-8 -*-
require File.expand_path('../lib/joyce/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alessandro Morandi"]
  gem.email         = ["alessandro@dachisgroup.com"]
  gem.description   = %q{A gem to manage activity streams in Rails}
  gem.summary       = %q{Manage activity streams}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "joyce"
  gem.require_paths = ["lib"]
  gem.version       = Joyce::VERSION
  
  gem.add_development_dependency('rake', '~> 0.8')
  gem.add_development_dependency('rspec', '~> 2.8')
  gem.add_development_dependency('sqlite3')
  gem.add_development_dependency('database_cleaner')
  
  gem.add_runtime_dependency('activerecord')
end
