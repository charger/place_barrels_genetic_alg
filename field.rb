class Field
  FLOOR = 0
  WALL = 1
  BARREL = 2
  ENTRANCE = 3
  MARKED_FLOOR = 4
  COUNTED_BARREL = 5

  def initialize(field_arr)
    @arr = field_arr.map{|a| a.dup}
    @height = field_arr.size
    @width = field_arr[0].size
  end

  def place_barrels(vector)
    i = -1
    @height.times do |y|
      @width.times do |x|
        i += 1
        next if vector[i].to_i != 1 || @arr[y][x] != FLOOR
        @arr[y][x] = BARREL
      end
    end
  end

  def accessible_barrels_count
    return @accessible_barrels_count if @accessible_barrels_count != nil
    @accessible_barrels_count = 0
    begin
      marked_count = 0
      @height.times do |y|
        @width.times do |x|
          next unless @arr[y][x] == FLOOR || @arr[y][x] == ENTRANCE
          #mark floor if there is marked neighbour, and mark entrance as a starting point
          if y < @height - 1 && @arr[y + 1][x] == MARKED_FLOOR || y > 0 && @arr[y - 1][x] == MARKED_FLOOR ||
            x < @width - 1 && @arr[y][x + 1] == MARKED_FLOOR || x > 0 && @arr[y][x - 1] == MARKED_FLOOR ||
            @arr[y][x] == ENTRANCE

            @arr[y][x] = MARKED_FLOOR
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
    return if x < 0 || x >= @width || y < 0 || y>= @height
    return if @arr[y][x] != BARREL
    @accessible_barrels_count += 1
    @arr[y][x] = COUNTED_BARREL
  end

  def print_field
    @height.times do |y|
      row = ''
      @width.times do |x|
        row += @arr[y][x].to_s
      end
      puts row
    end
  end
end
