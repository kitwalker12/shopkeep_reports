# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shopkeep_reports/version'

Gem::Specification.new do |spec|
  spec.name          = "shopkeep_reports"
  spec.version       = ShopkeepReports::VERSION
  spec.authors       = ["Kunwar Aditya Raghuwanshi"]
  spec.email         = ["adi.version1@gmail.com"]
  spec.summary       = %q{Download Shopkeep Reports}
  spec.description   = %q{Gem for downloading shopkeep reports via mechanize}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "mechanize"
end
