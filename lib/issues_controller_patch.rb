module RedmineDueDateByDefault
  module Patches
    module IssuesControllerPatch
      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          alias_method_chain :update, :write_due_date
          alias_method_chain :create, :write_due_date
          alias_method_chain :new, :write_fixed_version
        end
      end

      module ClassMethods
      end

      module InstanceMethods
        def update_with_write_due_date
          issue = Issue.find(params[:id])
          begin
            new_version = Version.find(params[:issue][:fixed_version_id])
          rescue
          end           
          if !new_version.nil? && !new_version.due_date.nil?
            if params[:issue][:due_date].nil? || (params[:issue][:due_date] == '')
              params[:issue][:due_date] = new_version.due_date
            else
              current_version = issue.fixed_version
              if !current_version.nil? && (current_version.id != new_version.id) &&
                 (params[:issue][:due_date] == current_version.due_date.to_s)
                params[:issue][:due_date] = new_version.due_date
              end
            end
          end
          update_without_write_due_date              
        end

        def new_with_write_fixed_version
          project = Project.find(params[:project_id]) 
          field = project.custom_field_values.find {|field| field.custom_field_id == 21}
          if !field.nil?
            params[:issue] = {} if params[:issue].nil?
            params[:issue][:fixed_version_id] = field.value
            build_new_issue_from_params
          end
          new_without_write_fixed_version
        end

        def create_with_write_due_date
          if params[:issue][:due_date].nil? || (params[:issue][:due_date] == '')
            unless params[:issue][:fixed_version_id].nil?
              v = Version.find(params[:issue][:fixed_version_id])
              params[:issue][:due_date] = v.due_date unless v.due_date.nil?
            end
          end
          build_new_issue_from_params
          create_without_write_due_date
        end

      end

    end
  end
end
