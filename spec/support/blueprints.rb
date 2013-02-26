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
  author { Author.make }
  title { generate_tiny_text }
  genre { generate_tiny_text }
  content { generate_text }
end

Author.blueprint do
  publisher { Publisher.make }
  name { generate_tiny_text }
  biography { generate_text }
end

Publisher.blueprint do
  name { generate_tiny_text }
  location { generate_tiny_text }
end

ArticleReader.blueprint do
  article { Article.make }
  reader { Reader.make }
end

Reader.blueprint do
  name { generate_tiny_text }
  age { generate_age }
end

