class WhitePiecesFactory

  attr_reader :pieces, :board

  def initialize( board )
    @board = board
    @pieces = []
    create_pawns
    create_rooks
    create_bishops
    create_knights
    create_queen
    create_king
  end

  def create_pawns
    8.times do |rank|
      pieces << Pawn.new( "♙", 1, rank, :white, board, :down )
    end
  end

  def create_rooks
    [[0, 0], [0, 7]].each do |file, rank|
      pieces << Rook.new( "♖", file, rank, :white, board )
    end
  end

  def create_bishops
    [[0,1], [0,6]].each do |file, rank|
      pieces << Bishop.new( "♖", file, rank, :white, board )
    end
  end

  def create_knights
    [[0,2], [0,5]].each do |file, rank|
      pieces << Knight.new( "♘", file, rank, :white, board )
    end
  end

  def create_queen
    pieces << Queen.new( "♕", 0, 3, :white, board )
  end

  def create_king
    pieces << King.new( "♔", 0, 3, :white, board )
  end
end