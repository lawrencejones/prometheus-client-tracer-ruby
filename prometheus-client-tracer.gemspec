# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "prometheus-client-tracer"
  spec.version       = "1.0.0"
  spec.summary       = "Tracer for accurate duration tracking with Prometheus metrics"
  spec.authors       = %w[me@lawrencejones.dev]
  spec.homepage      = "https://github.com/lawrencejones/prometheus-client-tracer"
  spec.email         = %w[me@lawrencejones.dev]
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.4"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_dependency "prometheus-client", "~> 0.10.0.alpha"

  spec.add_development_dependency "gc_ruboconfig", "= 2.4.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "ruby-prof", "~> 0.18"
end
