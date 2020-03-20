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
  gem.summary       = 'Mongoid extension that adds the ability to handle events in a timeline for an entity (e.g. User).'
  gem.description   = 'Obscured::Timeline is a Mongoid extension adds events to a separate collection for an entity (e.g. User), the naming of the class (Mongoid Document) is used for naming the timeline collection, so if the class is named "Account" the collection name will end up being "account_timeline".'
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
