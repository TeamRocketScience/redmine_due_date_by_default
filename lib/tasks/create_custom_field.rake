namespace :redmine do
  namespace :due_date_by_default do
    desc "Create project custom field called \"Current Version\""
    task :create_custom_field do
      field = ProjectCustomField.create(:name => 'Current version', :field_format => 'version')
      puts "Custom field id is ##{field.id}"
    end
  end
end
