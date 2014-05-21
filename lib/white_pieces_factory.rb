class WhitePiecesFactory
  ROOKS_STARTING_POSITIONS = [["a", 8], ["h", 8]]
  BISHOPS_STARTING_POSITIONS = [["c",8], ["f",8]]
  KNIGHTS_STARTING_POSITIONS = [["b",8], ["g",8]]

  attr_reader :pieces, :board

  def initialize( board )
    @board = board
    @pieces = []
  end

  def create_pawns
    8.times do |file|
      pieces << Pawn.new( "♙", Position::FILE_POSITIONS[file], 7, :white, board, :down )
    end
  end

  def create_rooks
    ROOKS_STARTING_POSITIONS.each do |file, rank|
      pieces << Rook.new( "♖", file, rank, :white, board )
    end
  end

  def create_bishops
    BISHOPS_STARTING_POSITIONS.each do |file, rank|
      pieces << Bishop.new( "♗", file, rank, :white, board )
    end
  end

  def create_knights
    KNIGHTS_STARTING_POSITIONS.each do |file, rank|
      pieces << Knight.new( "♘", file, rank, :white, board )
    end
  end

  def create_queen
    pieces << Queen.new( "♕", "d", 8, :white, board )
  end

  def create_king
    pieces << King.new( "♔", "e", 8, :white, board )
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