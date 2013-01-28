# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'form_model/version'

Gem::Specification.new do |gem|
  gem.name          = "form_model"
  gem.version       = FormModel::VERSION
  gem.authors       = ["hookercookerman"]
  gem.email         = ["hookercookerman@gmail.com"]
  gem.description   = %q{A Library to create Form objects to encapsulate forms}
  gem.summary       = %q{A Library to create Form objects to encapsulate forms}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'virtus', '>=0.5.0'
  gem.add_dependency "activemodel", ">= 3.0.0"
  gem.add_dependency "activesupport", ">= 3.0.0"

  gem.add_development_dependency "rspec", "~> 2.11.0"
  gem.add_development_dependency "factory_girl", "~> 4.0.0"
  gem.add_development_dependency "fuubar", "~> 1.0.0"
  gem.add_development_dependency "activemodel", "~> 3.2.8"
  gem.add_development_dependency 'rake'
end
