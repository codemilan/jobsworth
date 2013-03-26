When /I am on current common user "([^\"]*)" edit page$/ do |model|
  step %Q{I am on the edit company page with params "{ :id => @current_user.#{model}.id }"}
end

When /I am on current common user (\d+). "([^\"]*)" edit page$/ do |nth, model|
  step %Q{I am on the edit #{model} page with params "{ :id => @current_user.#{model.pluralize}[#{nth.to_i - 1}].id }"}
end

When /I am on a property page$/ do
  visit edit_property_path Proprety.first
end

Given /I have all score rules related test data and logged in as (\w+)$/ do |u|
  @current_user = user = FactoryGirl.create(u.to_sym)
  project = FactoryGirl.create :project, :company => user.company
  FactoryGirl.create :project_permission, :company => user.company, :user => user, :project => project

  FactoryGirl.create(:milestone, :user => user, :project => project)
#  FactoryGirl.create(:property, :company => user.company)
  step %Q{I am logged in as current user}
end
