class Field
  FLOOR = '0'
  WALL = '1'
  BARREL = '2'
  ENTRANCE = '3'
  MARKED_FLOOR = '4'
  COUNTED_BARREL = '5'

  def initialize(field_seq, width, height)
    @height = height
    @width = width
    @seq = field_seq.dup
  end

  def cell(x, y)
    @seq[dec_to_seq(x, y)]
  end

  def set_cell(x, y, value)
    @seq[dec_to_seq(x, y)] = value
  end

  def dec_to_seq(x, y)
    raise "X=#{x} out of bound (0..#{@width - 1})" if x < 0 || x >= @width
    raise "Y=#{y} out of bound (0..#{@height - 1})" if y < 0 || y >= @height
    y * @width + x
  end

  def place_barrels(vector)
    (vector.size).times do |i|
      next if vector[i] != '1' || @seq[i] != FLOOR
      @seq[i] = BARREL
    end
  end

  def accessible_barrels_count
    return @accessible_barrels_count if @accessible_barrels_count != nil
    @accessible_barrels_count = 0
    begin
      marked_count = 0
      @height.times do |y|
        @width.times do |x|
          next unless cell(x, y) == FLOOR || cell(x, y) == ENTRANCE
          #mark floor if there is marked neighbour, and mark entrance as a starting point
          if y < @height - 1 && cell(x, y + 1) == MARKED_FLOOR || y > 0 && cell(x, y - 1) == MARKED_FLOOR ||
            x < @width - 1 && cell(x + 1, y) == MARKED_FLOOR || x > 0 && cell(x - 1, y) == MARKED_FLOOR ||
            cell(x, y) == ENTRANCE

            set_cell(x, y, MARKED_FLOOR)
            marked_count += 1
            #count barrels around
            check_barrel_at(x - 1, y)
            check_barrel_at(x + 1, y)
            check_barrel_at(x, y - 1)
            check_barrel_at(x, y + 1)
          end
        end
      end
    end while marked_count > 0
    @accessible_barrels_count
  end

  def check_barrel_at(x, y)
    return if x < 0 || x >= @width || y < 0 || y >= @height
    return if cell(x, y) != BARREL
    @accessible_barrels_count += 1
    set_cell(x, y, COUNTED_BARREL)
  end

  def print_field
    @height.times do |y|
      puts @seq[@width * y, @width].
        gsub(COUNTED_BARREL, "\e[32m#{COUNTED_BARREL}\e[0m").
        gsub(MARKED_FLOOR, "\e[37m#{MARKED_FLOOR}\e[0m")
    end
    nil
  end
end
