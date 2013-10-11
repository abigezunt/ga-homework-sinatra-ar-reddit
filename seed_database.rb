require 'faker'
require_relative 'main'

Comment.delete_all
Post.delete_all

10.times do |i|
  post = Post.create(:title => Faker::Lorem.sentence(1), :link => Faker::Internet.url, :body => Faker::Lorem.paragraphs(i).join("\n"))

  i.times do |comment_count|
    post.comments << Comment.new(:author => Faker::Name.name, :body => Faker::Lorem.paragraphs(comment_count).join("\n"))
  end
end

