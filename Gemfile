source "http://rubygems.org"

gem "pg", platforms: [:ruby]

platforms :rbx do
  gem "rubysl", "~> 2.0"
  gem "rubinius-developer_tools"
  gem "rubysl-test-unit"
end

# Specify your gem"s dependencies in acts_as_list-rails3.gemspec
gemspec

gem "rake"
gem "appraisal"

group :test do
	gem "minitest", "~> 5.0"
end
