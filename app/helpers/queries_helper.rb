if Redmine::VERSION::MAJOR < 2
  module QueriesHelper

    require_dependency File.expand_path('../../../inc/qpp_queries_helper.rb', __FILE__)
  end
end
