# coding: utf-8
require File.expand_path("../lib/flynn/cli/tools/version", __FILE__)
Gem::Specification.new do |spec|

  spec.name          = "flynn-cli-tools"
  spec.version       = Flynn::CLI::Tools::VERSION
  spec.authors       = ["Kenaniah Cerny"]
  spec.email         = ["kenaniah@gmail.com"]

  spec.summary       = "A collection of CLI tools for administrating Flynn (flynn.io)"
  spec.homepage      = "https://github.com/kenaniah/flynn-cli-tools"

  spec.files         = `git ls-files -z`.split("\x0").select{ |f| f.match /(lib|bin)\// }

  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'table_print'
  spec.add_dependency 'commander'
  spec.add_dependency 'json'
  spec.add_dependency 'httparty'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

end
