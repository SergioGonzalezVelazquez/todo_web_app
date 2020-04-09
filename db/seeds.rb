# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Creating the first admin user
unless User.exists?(email: 'admin@todoapp.com')
  User.create!(email: 'admin@todoapp.com', password: 'Administrator.', password_confirmation: 'Administrator.', username: 'admin', first_name: 'admin', surname: 'user', admin: true)
end
