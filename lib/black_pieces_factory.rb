class BlackPiecesFactory
  ROOKS_STARTING_POSITIONS = [["a", 1], ["h", 1]]
  BISHOPS_STARTING_POSITIONS = [["c",1], ["f",1]]
  KNIGHTS_STARTING_POSITIONS = [["b",1], ["g",1]]

  attr_reader :pieces, :board

  def initialize( board )
    @board = board
    @pieces = []
  end

  def create_pawns
    8.times do |file|
      pieces << Pawn.new( "♟", Position::FILE_POSITIONS[file], 2, :black, board, :up )
    end
  end

  def create_rooks
    ROOKS_STARTING_POSITIONS.each do |file, rank|
      pieces << Rook.new( "♜", file, rank, :black, board )
    end
  end

  def create_bishops
    BISHOPS_STARTING_POSITIONS.each do |file, rank|
      pieces << Bishop.new( "♝", file, rank, :black, board )
    end
  end

  def create_knights
    KNIGHTS_STARTING_POSITIONS.each do |file, rank|
      pieces << Knight.new( "♞", file, rank, :black, board )
    end
  end

  def create_queen
    pieces << Queen.new( "♛", "d", 1, :black, board )
  end

  def create_king
    pieces << King.new( "♚", "e", 1, :black, board )
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