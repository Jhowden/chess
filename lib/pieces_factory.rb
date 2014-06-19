class PiecesFactory
  WHITE_ROOKS_STARTING_POSITIONS   = [["a", 8], ["h", 8]]
  WHITE_BISHOPS_STARTING_POSITIONS = [["c",8], ["f",8]]
  WHITE_KNIGHTS_STARTING_POSITIONS = [["b",8], ["g",8]]
  BLACK_ROOKS_STARTING_POSITIONS   = [["a", 1], ["h", 1]]
  BLACK_BISHOPS_STARTING_POSITIONS = [["c",1], ["f",1]]
  BLACK_KNIGHTS_STARTING_POSITIONS = [["b",1], ["g",1]]

  attr_reader :pieces, :board, :team

  def initialize( board, team )
    @board = board
    @team = team
    @pieces = []
  end

  def create_pawns
    8.times do |file|
      if team == :white
        pieces << Pawn.new( Position::FILE_POSITIONS[file], 7, team, board, :down )
      else
        pieces << Pawn.new( Position::FILE_POSITIONS[file], 2, team, board, :up )
      end
    end
  end

  def create_rooks
    if team == :white
      WHITE_ROOKS_STARTING_POSITIONS.each do |file, rank|
        pieces << Rook.new( file, rank, team, board )
      end
    else
      BLACK_ROOKS_STARTING_POSITIONS.each do |file, rank|
        pieces << Rook.new( file, rank, team, board )
      end
    end
  end

  def create_bishops
    if team == :white
      WHITE_BISHOPS_STARTING_POSITIONS.each do |file, rank|
        pieces << Bishop.new( file, rank, team, board )
      end
    else
      BLACK_BISHOPS_STARTING_POSITIONS.each do |file, rank|
        pieces << Bishop.new( file, rank, team, board )
      end
    end
  end

  def create_knights
    if team == :white
      WHITE_KNIGHTS_STARTING_POSITIONS.each do |file, rank|
        pieces << Knight.new( file, rank, team, board )
      end
    else
      BLACK_KNIGHTS_STARTING_POSITIONS.each do |file, rank|
        pieces << Knight.new( file, rank, team, board )
      end
    end
  end

  def create_queen
    if team == :white
      pieces << Queen.new( "d", 8, team, board )
    else
      pieces << Queen.new( "d", 1, team, board )
    end
  end

  def create_king
    if team == :white
      pieces << King.new( "e", 8, team, board )
    else
      pieces << King.new( "e", 1, team, board )
    end
  end
  
  def build
    create_pawns
    create_rooks
    create_bishops
    create_knights
    create_queen
    create_king
  end
end