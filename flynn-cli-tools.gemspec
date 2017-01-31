# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "flynn-cli-tools"
  spec.version       = "0.0.1"
  spec.authors       = ["Kenaniah Cerny"]
  spec.email         = ["kenaniah@gmail.com"]

  spec.summary       = "A collection of CLI tools for administrating Flynn (flynn.io)"
  spec.homepage      = "https://github.com/kenaniah/flynn-cli-tools"

  spec.files         = `git ls-files -z`.split("\x0").select{ |f| f.match /(lib|exe)\// }

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
