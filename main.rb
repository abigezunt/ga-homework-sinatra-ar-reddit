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
