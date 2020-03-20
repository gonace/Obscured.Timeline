# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'obscured-timeline/version'

Gem::Specification.new do |gem|
  gem.name          = 'obscured-timeline'
  gem.version       = Mongoid::Timeline::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.licenses      = ['MIT']
  gem.authors       = ['Erik Hennerfors']
  gem.email         = ['erik.hennerfors@obscured.se']
  gem.description   = 'Mongoid extension that handles a timeline of events for an entity (e.g. User)'
  gem.summary       = 'Mongoid extension that adds the ability to handle events in a timeline for a entity (e.g. User)'
  gem.homepage      = 'https://github.com/gonace/Obscured.Timeline'

  gem.required_ruby_version = '>= 2'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'activesupport'
  gem.add_dependency 'mongoid'
  gem.add_dependency 'mongoid_search'

  gem.add_development_dependency 'factory_bot'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
end
