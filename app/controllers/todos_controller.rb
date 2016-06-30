# encoding: UTF-8
class TodosController < ApplicationController
  before_filter :load_task, :except => [:list_clone, :toggle_done_for_uncreated_task]
  before_filter :load_todo, :only => [:update, :toggle_done, :destroy]

  def create
    @todo = @task.todos.build(todo_attributes)
    @todo.creator_id = current_user.id
    @todo.save

    render :file => '/todos/todos_container.json.erb'
  end

  def update
    @todo.update_attributes(todo_attributes)
    render :partial => 'todos'
  end

  def toggle_done
    if @todo.done?
      @todo.completed_at = nil
      @todo.completed_by_user_id = nil
    else
      @todo.completed_at = Time.now
      @todo.completed_by_user_id = current_user.id
    end

    @todo.save
    render :file => '/todos/todos_container.json.erb'
  end

  def toggle_done_for_uncreated_task
    todo = Todo.new(:creator_id => current_user.id, :name => params[:name])
    if params[:id] == 'true'
      todo.completed_at = Time.now
      todo.completed_by_user_id = current_user.id
    else
      todo.completed_at = nil
      todo.completed_by_user_id = nil
    end

    render :partial => '/todos/new_todo', :locals => {:todo => todo}
  end

  def destroy
    @todo.destroy
    render :file => '/todos/todos_container.json.erb'
  end

  def reorder
    params[:todos].values.each{ |todo| t=@task.todos.find(todo[:id]); t.position=todo[:position]; t.save!}
    render :nothing=>true
  end

  #for todos at task creation page (from template)
  def list_clone
    @task = TaskRecord.new
    Template.find(params[:id]).clone_todos.collect{|t| @task.todos.build(t.attributes) }

    render :partial => 'todos_clone'
  end

  private

    def load_task
      @task = TaskRecord.accessed_by(current_user).find_by(:id => params[:task_id])
      ###################### code smell begin ################################################################
      # this code allow usage  TodosController in TaskTemplatesController#edit
      #NOTE: Template is a Task, using single table inheritance
      if @task.nil?
        @task= Template.where('company_id = ?', current_user.company_id).find_by(:id => params[:task_id])
      end
      ###################### code smell end ##################################################################
      if @task.nil?
        flash[:error] = t('flash.alert.access_denied_to_model', model: Todo.model_name.human)
        redirect_from_last
      end
    end

    def load_todo
      @todo = @task.todos.find(params[:id])
    end

    def todo_attributes
      params.require(:todo).permit :name, :completed_at, :position, :completed_by_user_id, :creator_id
    end
end
