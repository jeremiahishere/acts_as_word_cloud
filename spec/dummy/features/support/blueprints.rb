require 'machinist/active_record'
require 'faker'

def generate_age
  rand(60)+15
end

def generate_text
  Faker::Lorem.words(20).join(' ') 
end

def generate_tiny_text
  Faker::Lorem.words(3).join(' ') 
end

Article.blueprint do
  author = Author.make
  author_id { author.id }
  publisher_id { author.publisher.id }
  site_id { author.site.id }
  title { generate_tiny_text }
  genre { generate_tiny_text }
  content { generate_text }
end

Author.blueprint do
  site = Site.make
  site_id { site.id }
  publisher_id { site.publisher.id }
  name { generate_tiny_text }
  genre { generate_tiny_text }
  age { generate_age }
end

Publisher.blueprint do
  name { generate_tiny_text }
  location { generate_tiny_text }
end

Following.blueprint do
  special_name { generate_tiny_text }
  article_id { Article.make }
  reader_id { Reader.make }
end

Reader.blueprint do
  site_id { Site.make }
  username { generate_tiny_text }
  age { generate_age }
end

Site.blueprint do
  publisher_id { Publisher.make }
  name { generate_tiny_text }
  domain { generate_tiny_text }
  genre { generate_tiny_text }
end
