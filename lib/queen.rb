$LOAD_PATH.unshift( File.expand_path(File.dirname( __FILE__ ) ) ) unless $LOAD_PATH.include?( File.expand_path(File.dirname( __FILE__ ) ) )
require 'chess_piece'

class Queen < ChessPiece

  attr_reader :board_marker

  def initialize( file, rank, team, board )
    super
    @board_marker = determine_board_marker
  end

  def determine_possible_moves
    clear_moves!

    possible_moves.concat( board.find_horizontal_spaces( self ) )
    possible_moves.concat( board.find_vertical_spaces( self ) )
    possible_moves.concat( board.find_diagonal_spaces( self ) )

    possible_moves
  end

  def determine_board_marker
    team == :white ? "♕" : "♛"
  end
end