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

puts "===== Checking Positions =====\n"

if Position.where(latitude: 0.., longitude: 0..).empty?
  Position.all.sample(2).each do |position|
    position.update(latitude: rand(0.0..90.0).round(6),
                    longitude: rand(0.0..180.0).round(6))
  end
end

puts '===== Generating Infections ====='

Survivor.limit(3).each do |informer|
  Survivor.last.infections.create(informer: informer)
end

Survivor.fourth.infections.create(informer: Survivor.last)

puts '===== Seeds done ====='
