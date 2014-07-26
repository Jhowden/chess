class UserCommands
  
  VALID_USER_MOVE_INPUT = /^[a-h]{1}[1-8]{1}\s{1}[a-h]{1}[1-8]{1}$/
  VALID_QUEENSIDE_CASTLING_INPUT = /^0-0-0$/
  VALID_KINGSIDE_CASTLING_INPUT = /^0-0$/
  VALID_EN_PASSANT_EXPRESSION = /^[a-h]{1}[1-8]{1}\s{1}[a-h]{1}[1-8]{1}\se.p.$/
  
  VALID_EXPRESSIONS_COLLECTION = [VALID_USER_MOVE_INPUT, VALID_QUEENSIDE_CASTLING_INPUT, 
                                  VALID_KINGSIDE_CASTLING_INPUT, VALID_EN_PASSANT_EXPRESSION]
  VALID_CASTLING_EXPRESSION = [VALID_QUEENSIDE_CASTLING_INPUT, VALID_KINGSIDE_CASTLING_INPUT]
  

  def user_input
    print "> "
    gets.chomp
  end

  def user_team_input
    input = user_input
    if ["white", "black"].any? { |color| color == input.downcase}
      input.downcase
    else
      puts "That is not a valid color. Please choose again (white or black):"
      user_team_input
    end
  end

  def user_move_input
    input = user_input
    
    if VALID_EXPRESSIONS_COLLECTION.any? { |expression| input =~ expression }
      input
    else
      puts "Please enter a correctly formated move (ex: b3 b6, 0-0 to castle kingside, or 0-0-0 to castle queenside):"
      user_move_input
    end
  end
end