$:.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'hellobase/formtastic/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'hellobase-formtastic'
  spec.version     = Hellobase::Formtastic::VERSION
  spec.authors     = ['Anthony Wang']
  spec.email       = ['awang@kodia.com']
  spec.summary     = 'Custom Formtastic inputs'
  spec.license     = 'MIT'
  spec.homepage    = 'https://github.com/K0D1A/hellobase-formtastic'

  spec.files = Dir['{lib}/**/*', 'MIT-LICENSE']

  spec.add_dependency 'activeadmin',   '~> 3'
  spec.add_dependency 'activesupport', '~> 7.0'
  spec.add_dependency 'tod',           '~> 2'

  spec.add_development_dependency 'activemodel',  '~> 7.0'
  spec.add_development_dependency 'activerecord', '~> 7.0'
  spec.add_development_dependency 'actionview',   '~> 7.0'
  spec.add_development_dependency 'minitest',     '~> 5'
  spec.add_development_dependency 'nokogiri',     '~> 1'
end
