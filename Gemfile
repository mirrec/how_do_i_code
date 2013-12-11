source 'http://rubygems.org'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'turbo-sprockets-rails3'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

if ENV["LOAD_GEMS_FROM_LOCAL"] == "1"
  gem "select2_field", :path => "~/Sites/select2_field"
  gem "datetime_picker_field", :path => "~/Sites/datetime_picker_field"
  gem "file_upload", :path => "~/Sites/file_upload"

  gem "wnm_core", :path => "~/Sites/wnm_core"
  gem "wnm_pages", :path => "~/Sites/wnm_pages"
  gem "wnm_customers", :path => "~/Sites/wnm_customers"
  gem "wnm_novelties", :path => "~/Sites/wnm_novelties"
  gem "wnm_galleries", :path => "~/Sites/wnm_galleries"
  gem "wnm_banners", :path => "~/Sites/wnm_banners"
else
  gem "select2_field", :git => "git@bitbucket.org:mirrec/select2_field.git", :ref => "b9205e3e42f48137a360164ba7482981546419cd"
  gem "datetime_picker_field", :git => "git@bitbucket.org:mirrec/datetime_picker_field.git", :ref => "d1af62953005bd6a497c927b00d4c4ac73b025fd"
  gem "file_upload", :git => "git@bitbucket.org:mirrec/file_upload.git", :ref => "34f3d10eea238d83306aab5a678d52391264d3c7"

  gem "wnm_core", :git => "git@bitbucket.org:mirrec/wnm_core.git", :tag => "v2.0.0"
  gem "wnm_pages", :git => "git@bitbucket.org:mirrec/wnm_pages.git", :tag => "v2.0.0"
  gem "wnm_customers", :git => "git@bitbucket.org:mirrec/wnm_customers.git", :tag => "v2.0.0"
  gem "wnm_novelties", :git => "git@bitbucket.org:mirrec/wnm_novelties.git", :tag => "v2.0.1"
  gem "wnm_galleries", :git => "git@bitbucket.org:mirrec/wnm_galleries.git", :tag => "v2.0.0"
  gem "wnm_banners", :git => "git@bitbucket.org:mirrec/wnm_banners.git", :tag => "v2.4.0"
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem "select2-rails"

gem "pry"
gem "hirb"
gem "exception_notification"
gem "prawn"
gem "prawnto_2", :require => "prawnto"
gem "capistrano"
gem "rvm-capistrano"
gem "whenever", :require => false

group :development, :test do
  gem "launchy"
  gem "letter_opener"
  gem "rspec-rails"
  gem "fuubar"
  gem "ipsum"
end

group :test do
  gem "fuubar"
  gem "capybara"
  gem "database_cleaner"
  gem "selenium-webdriver"
  gem "factory_girl_rails"
  gem "timecop"
  gem "escape_utils"
  gem "active_record_no_table"
end
