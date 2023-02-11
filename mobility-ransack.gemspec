
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

  spec.files         = Dir["{lib/**/*,[A-Z]*}"]
  spec.require_paths = ["lib"]

  spec.add_dependency "ransack",  ">= 1.8.0", "< 5.0"
  spec.add_dependency "mobility", ">= 1.0.1", "< 2.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "sqlite3", "~> 1.3", ">= 1.3.0"
  spec.add_development_dependency "database_cleaner", "~> 1.7", ">= 1.7.0"
end
