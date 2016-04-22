# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_variant_options'
  s.version     = '0.0.1'
  s.summary     = 'Solidus Variant Options is a simple solidus extension that replaces the radio-button variant selection with groups of option types and values.'
  s.description = 'Solidus Variant Options is a simple solidus extension that replaces the radio-button variant selection with groups of option types and values. Please see the documentation for more details.'
  s.required_ruby_version = '>= 2.1'

  s.authors    = ['Allison Reilly', 'Tim Hogg']
  s.email     = 'allie.reilly@boomer.digital'
  s.homepage  = 'http://www.boomer.digital'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = "lib"
  s.requirements << "none"

  s.add_dependency "solidus", "~> 1.2"

  s.add_development_dependency "rspec-rails", "~> 3.2"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "sass-rails"
  s.add_development_dependency "coffee-rails"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "capybara"
  s.add_development_dependency "poltergeist"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "ffaker"
end
