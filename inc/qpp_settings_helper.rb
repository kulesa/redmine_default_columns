
#module SettingsHelper

  def dc_fill_projects_dropdown(project_id)

    plist = Project.find(:all, :conditions => Project.visible_condition(User.current) )

    return project_tree_options_for_select(plist, :selected => Project.find_by_id(project_id) )
  end

  def dc_fill_custom_fields_dropdown(cf_name)

    names = Array.new

    CustomField.find_all_by_type('ProjectCustomField').each do |f|
      names << f.name
    end

    return options_for_select(names, cf_name)
  end

#end
