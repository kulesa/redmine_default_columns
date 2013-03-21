require 'query_per_project_constants'

class QueryPerProjectController < ApplicationController
  unloadable

  before_filter :require_login

  def redirect_to_user_query
    q = Query.first(:conditions => ["name = ? AND user_id = ?", QPP_Constants::settings['my_home_query_name'],User.current.id])
    q = Query.find_by_name(QPP_Constants::MY_QUERY_HOME_NAME_DEFAULT) unless q
    if q
      redirect_to :controller => 'issues', :project_id => q.project, :query_id => q
    else
      redirect_to :controller => 'my', :action => 'page'
    end
  end

end
