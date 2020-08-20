$:.push File.expand_path("lib", __dir__)

# Maintain gem's version:
require "tiny_fake_redis/version"

Gem::Specification.new do |spec|
  spec.name          = "tiny_fake_redis"
  spec.version       = TinyFakeRedis::VERSION
  spec.authors       = ["Sampson Crowley"]
  spec.email         = ["sampsonsprojects@gmail.com"]

  spec.summary       = "Pretend to Access a Redis Server"
  spec.description   = <<~BODY
    The class in this Gem mimics the calls of `redis-rb` to allow running commands in development and test environments without the need to run a redis server instance

    It purposefully only implements a small subset of the most useful redis commands

    To create a fake instance: `redis = TinyFakeRedis.new`
  BODY
  spec.homepage      = "https://github.com/SampsonCrowley/tiny_fake_redis"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "zeitwerk", "~> 2",   ">= 2.2.2"
end
