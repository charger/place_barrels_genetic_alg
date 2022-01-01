require_relative 'field'
require_relative 'genetic_algorithm'

arr = [
  [1, 1, 1, 1, 1],
  [1, 0, 0, 0, 1],
  [1, 0, 0, 0, 1],
  [1, 0, 0, 0, 1],
  [1, 0, 0, 0, 1],
  [1, 1, 3, 1, 1],
]
solution = '110110010001010001001101100000'.split('')

fitness_func = lambda do |level_map|
  lambda do |solution|
    solution = solution.split('').map(&:to_i) if solution.kind_of?(String)
    f = Field.new(level_map)
    f.place_barrels(solution)
    f.accessible_barrels_count
  end
end

# check manually
# puts fitness_func.call(arr).call(solution)

ga = GeneticAlgorithm.new
chromosome_len = arr.size * arr[0].size
solution = ga.run(fitness_func.call(arr), chromosome_len, 0.6, 0.132, 100) rescue 'Not a integer'
puts "solution: #{solution}, chromosome_len: #{chromosome_len}"
