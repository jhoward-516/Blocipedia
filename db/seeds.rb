10.times do
    User.create!(
        email:  Faker::Internet.email,
        password:  Faker::Internet.password
    )
end

users = User.all
 
25.times do
    Wiki.create!(
        user:   users.sample,
        title:  Faker::Lorem.word,
        body:   Faker::Lorem.paragraphs
    )
end
 
 puts "Seed finished"
 puts "#{User.count} users created"
 puts "#{Wiki.count} wikis created"
 