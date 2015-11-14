# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

##### USERS #####

# admin user
User.create!(name:                  "Gino Mempin",
             email:                 "gino.mempin@gmail.com",
             password:              "123456",
             password_confirmation: "123456",
             admin:                 true,
             activated:             true,
             activated_at:          Time.zone.now)

# other test users
99.times do |n|
  name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
  email = "user-#{n+1}@test.com"
  password = "password"
  User.create!(name:                  name,
               email:                 email,
               password:              password,
               password_confirmation: password,
               admin:                 false,
               activated:             true,
               activated_at:          Time.zone.now)
end

##### TABLES #####

# guaranteed unoccupied
name = "T1"
max_persons = Random.new.rand(2..4)
num_persons = 0
total_bill = Random.new.rand(100..1000)
Table.create!(name:         name,
              max_persons:  max_persons,
              num_persons:  num_persons,
              total_bill:   total_bill)

# random occupied/unoccupied
2.upto(10) do |n|
  name = "T#{n}"
  max_persons = Random.new.rand(2..4)
  num_persons = Random.new.rand(0..max_persons)
  total_bill = Random.new.rand(100..1000)
  Table.create!(name:         name,
                max_persons:  max_persons,
                num_persons:  num_persons,
                total_bill:   total_bill)
end

##### ORDERS #####

# served
1.upto(5) do |n|
  name = "Order #{n}"
  price = Random.new.rand(30.0..500.0)
  quantity = Random.new.rand(1..4)
  served = true
  Order.create!(name:     name,
                price:    price,
                quantity: quantity,
                served:   served)
end

# pending
6.upto(10) do |n|
  name = "Order #{n}"
  price = Random.new.rand(30.0..500.0)
  quantity = Random.new.rand(1..4)
  served = false
  Order.create!(name:     name,
                price:    price,
                quantity: quantity,
                served:   served)
end
