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
  belongs_to :category
end

class Comment < ActiveRecord::Base
  has_many :subcomments
  belongs_to :submission

  # def print_subcomments
  #   subcomments = Comment.where(comment_id: self.id)
  #   subcomments.each_with_index do |subcomment, index|
  #     index.times do
  #       "  "
  #     end
  #     "#{subcomment.body} posted by #{subcomment.author} on #{subcomment.created_at}"
  #   end
  # end

end

class SubComment < Comment
end

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

get '/all-categories' do
  @categories = Category.all
  erb :all_categories
end

get '/r/:category_title/index' do
  @category_title = params[:category_title]
  @category = Category.where(title: params[:category_title]).first
  @submissions = @category.submissions.order("(up_votes - down_votes) DESC")
  erb :category_index
end

post '/r/:category_title/new' do
  @category_title = params[:category_title]
  @category = Category.where(title: params[:category_title]).first
  create_params = {title: params[:title], category_id: @category.id}
  create_params[params[:post_type]] = params[:post]
  Submission.create(create_params)
  redirect "/r/#{params[:category_title]}/index"
end

# post '/r/:category_title/delete-category' do
#   category_id = Category.where(title: params[:category_title]).first.id
#   Category.delete(category_id)
#   redirect '/all-categories'
# end


get '/r/:category_title/:submission_id/comments' do
  @submission = Submission.find(params[:submission_id])
  @category = Category.where(title: params[:category_title]).first
  @category_title = params[:category_title]
  @comments = @submission.comments.order("(up_votes - down_votes) DESC")
  erb :show_post
end

post '/r/:category_title/:submission_id/delete' do
  Submission.delete(params[:submission_id])
  redirect "/r/#{params[:category_title]}/index"
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
  @category_title = params[:category_title]
  @submission_id = params[:submission_id]
  @comment = Comment.find(params[:comment_id])
  erb :edit_comment
end

get '/r/:category_title/:submission_id/:comment_id/add-comment' do
  @submission = Submission.find(params[:submission_id])
  @parent_comment = Comment.find(params[:comment_id])
  @category_title = params[:category_title]
  @subcomments = Comment.where(comment_id: params[:comment_id])
  erb :add_comment
end

post '/r/:category_title/:submission_id/:comment_id/add-comment' do
  SubComment.create(author: params[:author], body: params[:body], submission_id: params[:submission_id], comment_id: params[:comment_id])
  redirect "/r/#{params[:category_title]}/#{params[:submission_id]}/comments"
end

post '/:category_title/:submission_id/:comment_id/update-comment' do
  comment = Comment.find(params[:comment_id])
  comment.author = params[:author]
  comment.body = params[:body]
  comment.save
  redirect "/r/#{params[:category_title]}/#{params[:submission_id]}/comments"
end

post '/r/:category_title/:submission_id/:comment_id/delete-comment' do
  Comment.delete(params[:comment_id])
  redirect "/r/#{params[:category_title]}/#{params[:submission_id]}/comments"
end

post '/r/:category_title/:submission_id/:comment_id/up_vote' do
  upvoted = Comment.find(params[:comment_id])
  upvoted.up_votes += 1
  upvoted.save
  redirect "/r/#{params[:category_title]}/#{params[:submission_id]}/comments"
end

post '/r/:category_title/:submission_id/:comment_id/down_vote' do
  downvoted = Comment.find(params[:comment_id])
  downvoted.down_votes += 1
  downvoted.save
  redirect "/r/#{params[:category_title]}/#{params[:submission_id]}/comments"
end



