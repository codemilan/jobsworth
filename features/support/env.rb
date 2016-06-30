# -*- encoding : utf-8 -*-

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.
require 'cucumber/rails'
require 'capybara/poltergeist'
require 'factory_girl'

# Capybara.register_driver :poltergeist do |app|
  # Capybara::Poltergeist::Driver.new(app, :js_errors => false )
# end

Capybara.javascript_driver = :poltergeist
Capybara.server_port = ENV['CAPYBARA_SERVER_PORT'] || 3340

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false


# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
begin
  DatabaseCleaner.strategy = :transaction
  # DatabaseCleaner.strategy = :deletion
rescue NameError
  raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     DatabaseCleaner.strategy = :truncation, {:except => %w[widgets]}
#   end
#
#   Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end
#

# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
Cucumber::Rails::Database.javascript_strategy = :transaction

Before do
  # if !$assets # for save_and_open_page
  #   %x[bundle exec rake assets:precompile]
  #   $assets = true
  # end
  FactoryGirl.reload
end

Before '@contact_creation_allowed' do
  Setting.contact_creation_allowed = true
end

Before '@contact_creation_forbidden' do
  Setting.contact_creation_allowed = false
end

After do |scenario|
  if scenario.status == :failed &&
    scenario.source_tag_names.include?('@save-page')
    save_and_open_page
  end
end
