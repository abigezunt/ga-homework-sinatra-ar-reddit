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

get '/r/:category' do
  category = Category.where(title: params[:category]).first
  @submissions = category.submissions
  erb :index
end
