# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'
Faker::Config.locale='fr'
Faker::UniqueGenerator.clear

# Supprimer toutes les données existantes
def reset_db()
  Article.destroy_all
  User.destroy_all
  # reset ID 
  
  ActiveRecord::Base.connection.tables.each do |t|
    # postgreSql
    # ActiveRecord::Base.connection.reset_pk_sequence!(t)
    # SQLite
    ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = '#{t}'") 
  end

  puts ('drop and reset all tables')
end

def create_users(number)
  number.times do |i|
    user = User.create!(
      email: Faker::Internet.unique.email,
      password: "1&Azert"
    )
  end
  puts("#{number} Users créés")
end


def create_articles(number)
  number.times do |i|
    article = Article.create!(
      title: Faker::Hobby.unique.activity,
      content: Faker::Lorem.paragraph(sentence_count: Faker::Number.between(from: 3, to: 7)),
      user_id: User.all.sample.id
    )
  end
  puts("#{number} Artciles créés")
end

# PERFORM SEEDING
reset_db();
create_users(2);
create_articles(5)