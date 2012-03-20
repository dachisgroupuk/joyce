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
  # See http://blog.wyeworks.com/2011/11/1/ruby-1-9-3-and-ruby-debug for info on getting
  #  ruby-debug working with Ruby 1.9.3-p0
  gem.add_development_dependency('ruby-debug19')
  gem.add_development_dependency('timecop')
  gem.add_development_dependency('factory_girl')
  
  gem.add_runtime_dependency('activerecord', '~> 3.2.0')

end
