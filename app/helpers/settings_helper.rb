if Redmine::VERSION::MAJOR < 2
  module SettingsHelper

    require_dependency File.expand_path('../../../inc/qpp_settings_helper.rb', __FILE__)
  end
end
