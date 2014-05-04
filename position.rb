class Position

  FILE_POSITIONS = ["a", "b", "c", "d", "e", "f", "g", "h"]
  
  attr_reader :file, :rank

  def initialize( file, rank )
    @file = file
    @rank = rank
  end
  
  def file_position_converter
    case file
    when FILE_POSITIONS[0] then 0
    when FILE_POSITIONS[1] then 1
    when FILE_POSITIONS[2] then 2
    when FILE_POSITIONS[3] then 3
    when FILE_POSITIONS[4] then 4
    when FILE_POSITIONS[5] then 5
    when FILE_POSITIONS[6] then 6
    when FILE_POSITIONS[7] then 7
    end
  end
  
  def rank_position_converter
    ( rank - 8 ).abs
  end
end