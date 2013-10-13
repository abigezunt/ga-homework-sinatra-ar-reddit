class AddCommentIdColumnToCommentsTable < ActiveRecord::Migration
  def up
  	add_column :comments, :comment_id, :integer
  end

  def down
  	remove_column :comments, :comment_id, :integer
  end
end
