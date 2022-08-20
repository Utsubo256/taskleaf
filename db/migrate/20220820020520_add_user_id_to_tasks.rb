class AddUserIdToTasks < ActiveRecord::Migration[7.0]
  def up
    execute "Delete FROM tasks;"
    add_reference :tasks, :user, null: false, index: true
  end

  def down
    remove_reference :tasks, :user, index: true
  end
end
