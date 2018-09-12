
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mobility/ransack/version"

Gem::Specification.new do |spec|
  spec.name          = "mobility-ransack"
  spec.version       = Mobility::Ransack::VERSION
  spec.authors       = ["Chris Salzberg"]
  spec.email         = ["chris@dejimata.com"]

  spec.summary       = %q{Search attributes translated by Mobility with Ransack.}
  spec.homepage      = "https://github.com/shioyama/mobility-ransack"
  spec.license       = "MIT"

  spec.files        = Dir['{lib/**/*,[A-Z]*}']
  spec.require_paths = ["lib"]

  spec.add_dependency 'ransack', '~> 1.8.0'
  spec.add_dependency 'mobility', '~> 0.8.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'sqlite3'
end
