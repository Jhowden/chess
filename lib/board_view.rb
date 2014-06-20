class BoardView

  attr_reader :new_board, :board
  FILE_MARKERS = %w[ — — a b c d e f g h]
  RANK_MARKERS = [8, 7, 6, 5, 4, 3, 2, 1, "—"]
  VERTICAL_BORDER_MARKERS = ["║"] * 8 +  ["╚"]
  HORIZONTAL_BORDER_MARKERS = ["═"] * 8

  def initialize( board, printer=BoardPrinter.new )
    @new_board = Array.new( 10 ) { |cell| Array.new( 10, "…" ) }
    @board = board
    set_vertical_markers( RANK_MARKERS, 0, 0)
    set_vertical_markers( VERTICAL_BORDER_MARKERS, 0, 1)
    set_horizontal_markers( FILE_MARKERS, 0, 9)
    set_horizontal_markers( HORIZONTAL_BORDER_MARKERS, 2, 8)
  end

  def display_board
    populate_new_board
    print_board
  end

  def print_board
    new_board.each do |row|
      print_row row
    end
  end

  def populate_new_board
    board.chess_board.each_with_index do |row, rank_index|
      row.each_with_index do |cell, file_index|
        clear_board_of_previous_markers( file_index + 2, rank_index  ) # this is super ugly and I hate it. #Yep. Not very clear. Perhaps, extract method to an informative name?
        if !cell.nil?  
          new_board[rank_index][file_index + 2] = cell.board_marker
        end
      end
    end
  end
  
  private 

  def print_row( row )
    print row.join( "  " )
      puts
  end

  def set_horizontal_markers( markers, counter, rank_position )
    markers.each do |marker|
      new_board[rank_position][counter] = marker
      counter += 1
    end
  end

  def set_vertical_markers( markers, counter, file_position )
    markers.each do |marker|
      new_board[counter][file_position] = marker
      counter += 1
    end
  end
  
  def clear_board_of_previous_markers( file, rank )
    new_board[rank][file] = "…"
  end
end