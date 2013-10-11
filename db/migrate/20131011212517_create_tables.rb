class CreateTables < ActiveRecord::Migration
  def up
  	create_table :categories do |t|
      t.text :title
  	end

  	create_table :submissions do |t|
  	  t.text :title
  	  t.text :author, default: 'anonymous'
  	  t.text :link
  	  t.text :body
  	  t.integer :up_votes, default: 0
  	  t.integer :down_votes, default: 0
  	  t.integer :category_id
  	  t.timestamps
  	end

  	create_table :comments do |t|
  	  t.string :author, default: "anonymous"
  	  t.text :body
  	  t.integer :story_id
  	  t.integer :up_votes, default: 0
  	  t.integer :down_votes, default: 0
  	  t.integer :submission_id
  	  t.timestamps
  	end

  end

  def down
  	drop_table :categories
  	drop_table :submissions
  	drop_table :comments
  end
end
