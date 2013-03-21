if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.routes.draw do
    match 'query_per_project/redirect_to_user_query', :to => 'query_per_project#redirect_to_user_query', :via => [:get, :post]
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.connect 'query_per_project/redirect_to_user_query', :controller => 'query_per_project', :action => 'redirect_to_user_query'
  end
end
