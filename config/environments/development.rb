# encoding: UTF-8
# frozen_string_literal: true

require File.expand_path('../shared', __FILE__)

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  config.active_record.default_timezone = :local

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
<<<<<<< HEAD
  config.action_mailer.raise_delivery_errors = false
　# rails_delivery_errors 設定為 false 可讓寄信時的錯誤被忽略，如果要 debug 就設 true
  config.action_mailer.default_url_options = { host: 'http://localhost:3000' }
<<<<<<< HEAD

  config.action_mailer.delivery_method = :sendmail

  　

=======
  　# 這邊填入的網址須要注意一下，他必須是絕對網址，且會被預設為 mail 中的 resource link
  　# 像我是用 devise 寄發驗證信，所以 confirmation_url(@resource, confirmation_token: @token)
  　# 中的 @resource 就會是 http://localhost:3000
  config.action_mailer.delivery_method = :smtp
  　# delivery_method 有三種寄信方式 :test、:sendmail 和 :smtp
  　# sendmail 須搭配 server 的 /user/bin/sendmail application
  　# 而這邊我是透過 mailgun(and gmail) 的 smtp 協定作寄信
  config.action_mailer.smtp_settings = config_for(:email).symbolize_keys
  # config_for 會讀取 config 目錄下的 YAML 設定檔，由於 smtp_settings 需帶入 Symbol key
　# 所以透過 .symbolize_keys 將 Hash 中的 String key 轉成 Symbol key
>>>>>>> parent of 2213023d... edit action mailer
=======
  
>>>>>>> parent of 1719da18... edit mail setting
end
