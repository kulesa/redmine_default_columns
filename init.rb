require 'redmine'
require 'query_per_project_constants'
require 'query_per_project_patches'

unless Redmine::Plugin.registered_plugins.keys.include?(:redmine_default_columns)
  Redmine::Plugin.register :redmine_default_columns do
    name 'Default queries per project'
    author 'Vitaly Klimov'
    author_url 'mailto:vvk@snowball.ru'
    description 'Plugin allows to apply default queries for individual project or for projects based on their type.'
    version '0.0.6'

    settings(:partial => 'settings/default_columns_settings',
             :default => {
               'query_templates_project_id' => '0',
               'type_custom_field_name' => QPP_Constants::TYPE_CUSTOM_FIELD_NAME,
               'default_query_name' => QPP_Constants::QUERY_DEFAULT_NAME,
               'my_default_query_name' => QPP_Constants::MY_QUERY_DEFAULT_NAME,
               'my_global_query_name' => QPP_Constants::MY_QUERY_GLOBAL_DEFAULT_NAME,
               'my_home_query_name' => QPP_Constants::MY_QUERY_HOME_NAME
             })

    requires_redmine :version_or_higher => '1.2.0'
  end
end

Dispatcher.to_prepare :redmine_default_columns do
  require_dependency 'queries_helper'

  unless QueriesHelper.included_modules.include? QueryPerProject::Patches::QueriesHelperPatch
    QueriesHelper.send(:include, QueryPerProject::Patches::QueriesHelperPatch)
  end
end
