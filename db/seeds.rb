# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

raise "\n => Database already with data, maybe db reset first?\n\n" unless Survivor.count.zero?

puts "===== Generating Survivors =====\n"
genders = ['male', 'female']

survivors_names = (1..5).map{|number| "Survivor #{number}"}.shuffle

survivors = [
  { name: survivors_names.first, gender: genders.sample },
  { name: survivors_names.second, gender: genders.sample },
  { name: survivors_names.third, gender: genders.sample },
  { name: survivors_names.fourth, gender: genders.sample },
  { name: survivors_names.fifth, gender: genders.sample }
]

Survivor.create(survivors)

puts "===== Generating Positions =====\n"

Survivor.all.each do |survivor|
  Position.create(survivor: survivor,
                  latitude: rand(-90.0..90.0).round(6),
                  longitude: rand(-180.0..180.0).round(6))
end

puts '===== Generating Infections ====='

Survivor.limit(3).each do |informer|
  Survivor.last.infections.create(informer: informer)
end

Survivor.fourth.infections.create(informer: Survivor.last)

puts '===== Seeds done ====='
