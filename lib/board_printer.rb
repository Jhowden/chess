class BoardPrinter

  def print_board( board )
    board.each do |row|
      print_row row
    end
  end

  def print_row( row )
    print row.join( "  " )
    puts
  end
end