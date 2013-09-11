source 'https://rubygems.org'

gem 'rails', '3.2.14'

gem 'haml-rails'
gem 'jquery-rails'

group :production do
  gem 'pg'
  gem 'puma'
end

group :assets do
  gem 'sass-rails',         '~> 3.2.3'
  gem 'coffee-rails',       '~> 3.2.1'
  gem 'uglifier',           '>= 1.0.3'
end

group :development do
  gem 'capistrano',         :require => false
  gem 'capistrano_colors',  :require => false
  gem 'capistrano-rbenv',   :require => false
  gem 'capistrano-puma',    :require => false
  gem 'guard',              :require => false
  gem 'guard-rspec',        :require => false
  gem 'guard-livereload',   :require => false
  gem 'rack-livereload'
  gem 'listen',             :require => false
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'annotate'
end

group :test do
  gem 'turn',               :require => false
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'database_cleaner',   '1.0.1'   # multiple adapter issue #224
end

