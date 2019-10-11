# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ZCRMSDK/version'

Gem::Specification.new do |spec|
  spec.name          = 'ZCRMSDK'
  spec.version       = ZCRMSDK::VERSION
  spec.authors       = ['ZOHO CRM API TEAM']
  spec.email         = ['support@zohocrm.com']
  spec.summary       = 'API client for Zoho CRM '
  spec.description   = 'An API client for CRM customers, with which they can call ZOHO CRM APIs with ease'
  spec.homepage      = 'https://www.zoho.com/crm/'
  spec.metadata["source_code_uri"] = "https://github.com/zoho/zcrm-ruby-sdk"
  spec.files = Dir['lib/**/*']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_runtime_dependency 'multipart-post', '~> 2.0'
  spec.add_runtime_dependency 'rest-client', '~> 2.0'
  spec.add_runtime_dependency 'json', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'mysql2', '~> 0.5.2'
end
