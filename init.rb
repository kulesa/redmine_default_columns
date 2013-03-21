require 'redmine'
require 'query_per_project_constants'

unless Redmine::Plugin.registered_plugins.keys.include?(QPP_Constants::PLUGIN_NAME)
  Redmine::Plugin.register QPP_Constants::PLUGIN_NAME do
    name 'Default queries per project'
    author 'Vitaly Klimov'
    author_url 'mailto:vitaly.klimov@snowbirdgames.com'
    description 'Plugin allows to apply default queries for individual project or for projects based on their type.'
    version '0.1.1'

    settings(:partial => 'settings/default_columns_settings',
             :default => {
               'query_templates_project_id' => '0',
               'type_custom_field_name' => QPP_Constants::TYPE_CUSTOM_FIELD_NAME,
               'default_query_name' => QPP_Constants::QUERY_DEFAULT_NAME,
               'my_default_query_name' => QPP_Constants::MY_QUERY_DEFAULT_NAME,
               'my_global_query_name' => QPP_Constants::MY_QUERY_GLOBAL_DEFAULT_NAME,
               'my_home_query_name' => QPP_Constants::MY_QUERY_HOME_NAME
             })

    requires_redmine :version_or_higher => '1.3.0'
  end
end

if Rails::VERSION::MAJOR >= 3
  ActionDispatch::Callbacks.to_prepare do
    require 'query_per_project_patches'
  end
else
  Dispatcher.to_prepare QPP_Constants::PLUGIN_NAME do
    require_dependency 'query_per_project_patches'
  end
end
