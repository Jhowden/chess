require_relative 'bishop'
require_relative 'board_interface'
require_relative 'board'
require_relative 'chess_piece'
require_relative 'game'
require_relative 'king'
require_relative 'knight'
require_relative 'pawn'
require_relative 'player'
require_relative 'position'
require_relative 'queen'
require_relative 'rook'
require_relative 'white_pieces_factory'
require_relative 'black_pieces_factory'

board = Board.new
game = Game.new( board )
game.play!