source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_GEM_VERSION') ? "= #{ENV['PUPPET_GEM_VERSION']}" : '>= 3.3'

if RUBY_VERSION.start_with? '1.9'
  gem 'json_pure', '< 2.0'
  gem 'json', '< 2.0'
  gem 'rspec-puppet-facts', '< 1.4.0', :require => false
else
  gem 'rspec-puppet-facts', '>= 1.5', :require => false
end
gem 'puppet', puppetversion
gem 'puppetlabs_spec_helper', '>= 0.1.0'
gem 'puppet-lint', '>= 0.3.2'
gem 'facter', '>= 1.7.0'
gem "metadata-json-lint"
gem 'rspec-puppet'
gem 'simplecov', '>= 0.11.0'
gem 'simplecov-console'
gem 'rspec_junit_formatter'
