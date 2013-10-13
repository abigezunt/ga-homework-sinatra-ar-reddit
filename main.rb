require 'pry'
require 'pg'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'

set :database, {adapter: 'postgresql',
				database: 'reddit',
				host: 'localhost'}

class Category < ActiveRecord::Base
  has_many :submissions
end

class Submission < ActiveRecord::Base
  has_many :comments
end

class Comment < ActiveRecord::Base
  has_many :subcomments
end

class SubComment < Comment
end

@category_title = "Everything"

get '/index/' do
  @submissions = Submission.order("(up_votes - down_votes) DESC")
  erb :index
end

get '/new' do
  erb :new_category
end

post '/new/create' do
  Category.create(title: params[:title])
  redirect "/r/#{params[:title]}/index"
end

get '/newest' do
  @submissions = Submission.order("updated_at DESC")
  erb :index
end

get '/r/:category_title/index' do
  @category_title = params[:category_title]
  @category = Category.where(title: params[:category_title]).first
  @submissions = @category.submissions
  erb :category_index
end

post '/r/:category_title/new' do
  @category = Category.where(title: params[:category_title]).first
  Submission.create(title: params[:title], params[:post_type]: params[:post], category_id: @category.id)
  redirect "/r/#{params[:category_title]}/index"
end

get '/r/:category_title/:submission_id/comments' do
  @submission = Submission.find(params[:submission_id])
  @category = Category.where(title: params[:category_title]).first
  @category_title = params[:category_title]
  erb :show_post.erb
end

post '/r/:category_title/:submission_id/up_vote' do
  upvoted = Submission.find(params[:submission_id])
  upvoted.up_votes += 1
  upvoted.save
  redirect '/index/'
end

post '/r/:category_title/:submission_id/down_vote' do
  downvoted = Submission.find(params[:submission_id])
  downvoted.down_votes += 1
  downvoted.save
  redirect '/index/'
end

post '/r/:category_title/:submission_id/add-comment' do
  Comment.create(author: params[:author], body: params[:body], submission_id: params[:submission_id])
  redirect "/r/#{params[:category_title]}/#{params[:submission_id]}/comments"
end

get '/r/:category_title/:submission_id/:comment_id/edit-comment' do
  @comment = Comment.find(params[:comment_id])
  erb :edit_comment
end

post '/r/:category_title/:submission_id/:comment_id/delete-comment' do
  Comment.delete(params[:comment_id])
  redirect "/r/#{params[:category_title]}/#{params[:submission_id]}/comments"
end




