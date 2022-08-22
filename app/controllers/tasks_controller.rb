class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page]).per(30)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def confirm_new
    @task = current_user.tasks.new(task_params)
    render 'new', status: :unprocessable_entity unless @task.valid?
    render 'confirm_new', status: :unprocessable_entity
  end

  def create
    @task = current_user.tasks.new(task_params)
    if params[:back].present?
      render 'new', status: :unprocessable_entity
      return
    end
    
    if @task.save
      TaskMailer.creation_email(@task).deliver_now
      redirect_to @task, status: :see_other, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{@task.name}を更新しました。"
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, status: :see_other, notice: "タスク「#{@task.name}」を削除しました。"
  end

  private

    def task_params
      params.require(:task).permit(:name, :description)
    end

    def set_task
      @task = current_user.tasks.find(params[:id])
    end
end
