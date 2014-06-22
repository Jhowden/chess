require_relative "rooks_starting_positions"
require_relative "bishops_starting_positions"
require_relative "knights_starting_positions"

class PiecesFactory
  include RooksStartingPositions
  include BishopsStartingPositions
  include KnightsStartingPositions

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
      RooksStartingPositions::WHITE_ROOKS_STARTING_POSITIONS.each do |file, rank|
        pieces << Rook.new( file, rank, team, board )
      end
    else
      RooksStartingPositions::BLACK_ROOKS_STARTING_POSITIONS.each do |file, rank|
        pieces << Rook.new( file, rank, team, board )
      end
    end
  end

  def create_bishops
    if team == :white
      BishopsStartingPositions::WHITE_BISHOPS_STARTING_POSITIONS.each do |file, rank|
        pieces << Bishop.new( file, rank, team, board )
      end
    else
      BishopsStartingPositions::BLACK_BISHOPS_STARTING_POSITIONS.each do |file, rank|
        pieces << Bishop.new( file, rank, team, board )
      end
    end
  end

  def create_knights
    if team == :white
      KnightsStartingPositions::WHITE_KNIGHTS_STARTING_POSITIONS.each do |file, rank|
        pieces << Knight.new( file, rank, team, board )
      end
    else
      KnightsStartingPositions::BLACK_KNIGHTS_STARTING_POSITIONS.each do |file, rank|
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