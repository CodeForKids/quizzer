source 'https://rubygems.org'

ruby '2.1.1'

gem 'rails', '~> 4.1.0'
gem 'pg'

# Assets
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'

# App Specific Gems
gem 'bootstrap-sass', '~> 3.1.1'

gem 'rapidfire', git: 'git://github.com/jules2689/rapidfire'
gem 'devise', '~> 3.0.4'
gem 'simple_form'
gem 'ejs'

gem 'newrelic_rpm'

gem "fog", "~> 1.3.1", require: "fog/aws/storage"
gem "carrierwave"

group :development do
  gem 'pry-remote', '~> 0.1.7'
  gem 'quiet_assets'
end

group :production do
  gem 'rails_12factor'
end

group :test do
  gem 'factory_girl_rails'
  gem "mocha", git: "git://github.com/freerange/mocha.git", require: false
  gem "codeclimate-test-reporter"
end

group :development, :test do
  gem 'debugger'
end
