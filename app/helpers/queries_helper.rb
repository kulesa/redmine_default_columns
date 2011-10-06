module QueriesHelper
  def should_apply_for_default_query?
    return false unless params[:query_id].blank?
    if (api_request? || params[:set_filter] || session[:query].nil? ||
      session[:query][:project_id] != (@project ? @project.id : nil) ||
      session[:query][:column_names].nil? )
      return true
    end
    return false
  end

  def get_default_query
    @query = nil
    if params[:set_filter].nil?
      prj = Project.find_by_id(Setting.plugin_redmine_default_columns['query_templates_project_id'])
      custom_name = Setting.plugin_redmine_default_columns['type_custom_field_name']

      if @project
        query_default_name = Setting.plugin_redmine_default_columns['my_default_query_name']
        @query = Query.find_by_name(query_default_name, :conditions => "project_id = #{@project.id} AND user_id = #{User.current.id}")
        
        unless @query
          query_default_name = Setting.plugin_redmine_default_columns['default_query_name']
          @query = Query.find_by_name(query_default_name, :conditions => "project_id = #{@project.id}")
        end

        unless @query 
          if prj
            cv=@project.custom_values.detect do |custom_value|
              true if custom_value.custom_field.name == custom_name and !custom_value.value.blank?
            end
            template_str = ( cv ? cv.value.to_s.strip : QPP_Constants::PROJECT_DEFAULT_SUFFIX )
            @query = Query.find_by_name(QPP_Constants::QUERY_DEFAULT_PFX + template_str, :conditions => "project_id = #{prj.id}" )
          end
        end
      else
        query_default_name = Setting.plugin_redmine_default_columns['my_global_query_name']
        @query = Query.find_by_name(query_default_name, :conditions => "project_id IS NULL AND user_id = #{User.current.id}")

        unless @query
          @query = Query.find_by_name(QPP_Constants::QUERY_DEFAULT_GLOBAL_NAME, :conditions => "project_id IS NULL" ) if prj
          end
        end

        if @query
          @query = @query.clone
          @query.project = @project
          @query.name=QPP_Constants::QUERY_TEMP_NAME
          session[:query] = {:project_id => @query.project_id, :filters => @query.filters, :group_by => @query.group_by, :column_names => @query.column_names}
          session[sort_name]=@query.sort_criteria.to_param
        end
      end
  end
end
