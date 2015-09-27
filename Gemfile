source 'https://rubygems.org'
ruby "2.2.3" # matches the dev env ruby specified in .ruby-version
             # matches the supported ruby version of Heroku

gem 'rails',                      '4.2.2'
gem 'bcrypt',                     '>= 3.1.3'
gem 'bootstrap-sass',             '>= 3.2.0.0'
gem 'sass-rails',                 '5.0.2'     # fix to 5.0.2 to prevent issue with Heroku
gem 'font-awesome-sass',          '>= 4.3.0'
gem 'validates_email_format_of',  '>= 1.6.0'
gem 'uglifier',                   '~> 2.5.3'
gem 'coffee-rails',               '~> 4.1.0'
gem 'jquery-rails',               '~> 4.0.3'
gem 'turbolinks',                 '>= 2.3.0'
gem 'jbuilder',                   '~> 2.2.0'
gem 'sdoc',                       '~> 0.4.0', group: :doc

group :development, :test do
  gem 'sqlite3',                  '~> 1.3.0'
  gem 'byebug',                   '>= 3.4.0'
  gem 'web-console',              '>= 2.0.0'
  gem 'spring',                   '>= 1.1.3'
end

group :test do
  gem 'minitest-reporters',       '~> 1.0.5'
  gem 'mini_backtrace',           '~> 0.1.3'
  gem 'guard-minitest',           '~> 2.3.1'
end

# Heroku
group :production do
  gem 'pg',                       '~> 0.17.0'
  gem 'rails_12factor',           '~> 0.0.2'
  gem 'puma',                     '>= 2.11.1'
end
