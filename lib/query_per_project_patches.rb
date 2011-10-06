module QueryPerProject
  module Patches
    module QueriesHelperPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          alias_method_chain :retrieve_query, :default_query
        end
      end

      module InstanceMethods
        def retrieve_query_with_default_query
          # workaround bug in homepage plugin (if set to query_id, not possible to change custom at all)
          if !@project && params[:set_filter] && params[:query_id]
            params.delete(:query_id)
          end
          #
          if should_apply_for_default_query?
            get_default_query
            retrieve_query_without_default_query unless @query
          else
            retrieve_query_without_default_query
          end
        end
      end
    end
  end
end
