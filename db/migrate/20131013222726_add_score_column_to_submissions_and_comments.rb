class AddScoreColumnToSubmissionsAndComments < ActiveRecord::Migration
  def up
  	add_column :comments, :score, :integer, default: 0
  	add_column :submissions, :score, :integer, default: 0
  end

  def down
  	remove_column :comments, :score, :integer, default: 0
  	remove_column :submissions, :score, :integer, default: 0
  end
end
