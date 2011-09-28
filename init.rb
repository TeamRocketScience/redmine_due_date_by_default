require 'redmine'
require File.dirname(__FILE__) + '/lib/issues_controller_patch.rb'

require 'dispatcher'
Dispatcher.to_prepare :redmine_due_date_by_default do
  require_dependency 'issues_controller'
  IssuesController.send(:include, RedmineDueDateByDefault::Patches::IssuesControllerPatch)
end

Redmine::Plugin.register :redmine_due_date_by_default do
  name 'Redmine Due Date By Default plugin'
  author 'Max Prokopiev'
  description 'Automatically sets due date of the issue based on the date of the target version'
  version '0.0.1'
  url 'http://trs.io/'
  author_url 'http://github.com/juggler'
end
