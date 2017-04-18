Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-sqs-poll"
  spec.version       = "0.2.0"
  spec.authors       = ["Richard Li"]
  spec.email         = ["evilcat@wisewolfsolutions.com"]
  spec.description   = %q{fluent input plugin use aws-sdk v2 sqs poller to receive messages}
  spec.summary       = %q{fluent sqs poll input}
  spec.homepage      = "https://github.com/ecwws/fluent-plugin-sqs-poll"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "aws-sdk", '~> 2'
  spec.add_runtime_dependency "fluentd", '>= 0.14.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
