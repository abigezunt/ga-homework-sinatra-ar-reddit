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



get '/index/' do
  @category_name = "Everything"
  @submissions = Submission.order("(up_votes - down_votes) DESC")
  erb :index
end

get '/new' do
  erb :new_category
end

post '/new/create' do
  Submission.create(title: params[:title])
  redirect '/index/'
end

get '/newest' do
  @submissions = Submission.order("updated_at DESC")
  erb :index
end

get '/r/:category/index' do
  category = Category.where(title: params[:category]).first
  @category = params[:category]
  @submissions = category.submissions
  erb :index
end

get '/r/:category_id/:submission_id/comments' do
  @submission = Submission.find(params[:submission_id])
  @category_id = params[:category_id]
  @category_title = Category.find(params[:category_id]).title
  erb :show_post.erb
end

post '/r/:category_id/:submission_id/add-comment' do
  Comment.create(author: params[:author], body: params[:body], submission_id: params[:submission_id])
  redirect "/r/#{params[:category_id]}/#{params[:submission_id]}/comments"
end

get '/r/:category_id/:submission_id/:comment_id/edit-comment' do
  @comment = Comment.find(params[:comment_id])
  erb :edit_comment
end

post '/r/:category_id/:submission_id/:comment_id/delete-comment' do
  Comment.delete(params[:comment_id])
  redirect "/r/#{params[:category_id]}/#{params[:submission_id]}/comments"
end




