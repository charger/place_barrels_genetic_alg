require_relative 'field'
require_relative 'genetic_algorithm'

level_map = <<-TXT.gsub("\n", '')
1111111
1000001
1000001
1000001
1000001
1131111
TXT
width = 7
height = 6

solution = '110110010001010001001101100000'

fitness_func = lambda do |level_map, width, height|
  lambda do |solution|
    f = Field.new(level_map, width, height)
    f.place_barrels(solution)
    f.accessible_barrels_count
  end
end

# check manually
# puts fitness_func.call(level_map, width, height).call(solution)

ga = GeneticAlgorithm.new
chromosome_len = level_map.size
solution = ga.run(fitness_func.call(level_map, width, height), chromosome_len, 0.6, 0.132, 100) rescue 'Not a integer'
puts "solution: #{solution}, chromosome_len: #{chromosome_len}"

f = Field.new(level_map, width, height)
f.place_barrels(solution.chromosome)
f.accessible_barrels_count
f.print_field
