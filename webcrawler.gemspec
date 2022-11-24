# frozen_string_literal: true

Gem::Specification.new do |spec|
  # Basic information about the gem.
  spec.name = "webcrawler"
  spec.version = WebCrawler::version
  spec.authors = "Dustin Dugal"
  spec.summary = "A web crawler designed for use by automation projects."
  spec.description = gem.summary
  spec.homepage = "https://www.github.com/dsdugal/webcrawler"
  spec.metadata = {
    changelog_uri: "#{gem.homepage}/CHANGELOG.md",
    homepage_uri: gem.homepage,
    source_code_uri: gem.homepage
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir["lib/**/*", "CHANGELOG.md", "README.md"]

  # Specify which paths are included when the gem is required.
  spec.require_paths = ["lib"]

  # Specify which Ruby version(s) to use at runtime.
  spec.required_ruby_version = ">= 2.7.6"

  # Specify which Gems (and their versions) are dependencies.
  spec.add_runtime_dependency "addressable". "~> 2.8.0"
  spec.add_runtime_dependency "csv", "~> 3.1.2"
  spec.add_runtime_dependency "json", "~> 2.3.0"
  spec.add_runtime_dependency "nokogiri", "~> 1.13.6"
  spec.add_runtime_dependency "open-uri", "~> 0.2.0"
  spec.add_runtime_dependency "optparse", "~> 0.2.0"
  spec.add_runtime_dependency "pdf-reader", "~> 2.11.0"
  spec.add_runtime_dependency "pathname", "~> 0.2.0"
  spec.add_runtime_dependency "selenium-webdriver", "~> 4.4.0"
  spec.add_runtime_dependency "yaml", "~> 0.2.0"

  # Specify dependencies that are not included when the gem is required.
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
