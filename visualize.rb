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
solution = '101011001011010101100110000101011111101011'

f = Field.new(level_map, width, height)
f.place_barrels(solution)
puts f.accessible_barrels_count
f.print_field
