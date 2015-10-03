# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

##### USERS #####

# admin user
User.create!(name:                  "Gino Mempin",
             email:                 "gino.mempin@gmail.com",
             password:              "123456",
             password_confirmation: "123456")

# other test users
99.times do |n|
  name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
  email = "user-#{n+1}@test.com"
  password = "password"
  User.create!(name:                  name,
               email:                 email,
               password:              password,
               password_confirmation: password)
end
