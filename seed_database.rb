require 'faker'
require_relative 'main'

Comment.delete_all
Submission.delete_all

10.times do |i|
  submission = Submission.create(:title => Faker::Lorem.sentence(1), :link => Faker::Internet.url, :body => Faker::Lorem.paragraphs(i).join("\n"))

  i.times do |comment_count|
    submission.comments << Comment.new(:author => Faker::Name.name, :body => Faker::Lorem.paragraphs(comment_count).join("\n"))
  end
end

