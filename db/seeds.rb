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
name = "Table 1"
max_persons = Faker::Number.between(2, 4)
num_persons = 0
total_bill = Faker::Number.between(100, 1000)
Table.create!(name:         name,
              max_persons:  max_persons,
              num_persons:  num_persons,
              total_bill:   total_bill)

# random occupied/unoccupied
2.upto(10) do |n|
  name = "Table #{n}"
  max_persons = Faker::Number.between(2, 4)
  num_persons = Faker::Number.between(0, max_persons)
  total_bill = Faker::Number.between(100, 1000)
  Table.create!(name:         name,
                max_persons:  max_persons,
                num_persons:  num_persons,
                total_bill:   total_bill)
end

##### ORDERS #####

# randomly distributed orders for all occupied tables
tables = Table.where(occupied: true)
1.upto(10) do |n|
  name = "Order #{n}"
  price = Faker::Number.between(30.0, 500.0)
  tables.each do |table|
    if (Faker::Number.between(0, 1) > 0 ? true : false)
      quantity = Faker::Number.between(1, 4)
      served = (Faker::Number.between(0, 1) > 0 ? true : false)
      table.orders.create!(name:     name,
                           price:    price,
                           quantity: quantity,
                           served:   served)
    end
  end
end
