
require_relative 'main'

require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open('http://www.reddit.com'))
def seed_db(doc)
  doc.css('.thing').each do |thing|
    title = thing.css('.title').text
    link = "placekitten.com/#{rand(600)}/#{rand(500)}"
    Submission.create(title: title, link: link, category_id: rand(6))
  end
end

Category.create(title: 'Trombones')
Category.create(title: 'Polyamory')
Category.create(title: 'Magic: the Gathering')
Category.create(title: 'Motorcycles')
Category.create(title: 'Kittens')
Category.create(title: 'Local Politics')

seed_db(doc)