require 'rubygems'
#require 'simplecov'
#SimpleCov.start 'rails'
#require 'webmock/rspec'
#WebMock.disable_net_connect!(allow_localhost: true)
# require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.




# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
#require 'devise'
#require 'factory_girl_rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #config.include Mongoid::Matchers
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fabricators"


  #config.before(:suite) do
  #  DatabaseCleaner[:mongoid].strategy = :truncation
  #end
  #
  #config.before(:each) do
  #  DatabaseCleaner[:mongoid].start
  #end
  #
  #config.after(:each) do
  #  DatabaseCleaner[:mongoid].clean
  #end
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  #config.before(:suite) do
  #  DatabaseCleaner[:mongoid].strategy = :truncation
  #end
  #
  #config.before(:each) do
  #  DatabaseCleaner[:mongoid].start
  #end
  #
  #config.after(:each) do
  #  DatabaseCleaner[:mongoid].clean
  #end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation, :except => %w[base_system_parameters base_currencies base_countries base_state_provinces base_naics_codes base_ineligibility_reasons base_charge_codes base_sales_regions base_interest_rate_codes base_invoice_statuses base_cash_receipt_source_codes factoring_verification_parameters ] )
    Rails.application.load_seed # loading seeds
  end

  config.before(:each) do
    Borrower.delete_all
  end

  #config.include Devise::TestHelpers, :type => :controller
  #config.extend ControllerMacros, :type => :controller

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!
  config.before(:each) do
    stub_request(:get, /www.comerica.com/).
        with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(status: 200, body: "stubbed response", headers: {})

    #mock the security_links validation for lender fabricator
    security_link =  Rails.application.config.security_link
    stub_request(:head, security_link).
         with(headers: {'Accept'=>'*/*', 'Host'=> security_link.gsub("http://",""), 'User-Agent'=>'Ruby'}).
         to_return(status: 200, body: "", headers: {})
  end

  def set_request_header(token, type)
    request.env['CONTENT_TYPE'] = type
    request.env['HTTP_ACCEPT'] = type
    request.env['HTTP_X_AUTH_TOKEN'] = token if token
  end

 end
