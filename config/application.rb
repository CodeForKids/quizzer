require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CodeForKidsQuizzer
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.to_prepare do
      Devise::SessionsController.skip_before_filter :authenticate
      Devise::PasswordsController.skip_before_filter :authenticate
    end

    config.action_mailer.delivery_method = :smtp
    ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "code-for-kids.com",
    :user_name            => ENV['GMAIL_USER'],
    :password             => ENV['GMAIL_PASS'],
    :authentication       => "plain"
      # :enable_starttls_auto => true # I don't have this, but it should work anyway
    }

  end
end
