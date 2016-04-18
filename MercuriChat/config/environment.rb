# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Referenced from: http://stackoverflow.com/questions/9696487/undefined-method-default-content-type-in-actionmailer-in-rails-3-2-1
ActionMailer::Base.default :content_type => "text/html"

