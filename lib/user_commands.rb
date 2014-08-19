class UserCommands
  
  VALID_USER_MOVE_INPUT = /\A[a-h]{1}[1-8]{1}\s{1}[a-h]{1}[1-8]{1}\z/
  VALID_QUEENSIDE_CASTLING_INPUT = /\A0-0-0\z/
  VALID_KINGSIDE_CASTLING_INPUT = /\A0-0\z/
  VALID_EN_PASSANT_EXPRESSION = /\A[a-h]{1}[1-8]{1}\s?[a-h]{1}[1-8]{1}\s?e.p.\z/

  QUEEN_REPLACEMENT = /\AQueen\z/
  KNIGHT_REPLACEMENT = /\AKnight\z/
  ROOK_REPLACEMENT = /\ARook\z/
  BISHOP_REPLACEMENT = /\ABishop\z/
  VALID_REPLACEMENT_EXPRESSIONS = [QUEEN_REPLACEMENT, KNIGHT_REPLACEMENT, ROOK_REPLACEMENT,
                                   BISHOP_REPLACEMENT]
  
  VALID_EXPRESSIONS_COLLECTION = [VALID_USER_MOVE_INPUT, VALID_QUEENSIDE_CASTLING_INPUT, 
                                  VALID_KINGSIDE_CASTLING_INPUT, VALID_EN_PASSANT_EXPRESSION]
  VALID_CASTLING_EXPRESSION = [VALID_QUEENSIDE_CASTLING_INPUT, VALID_KINGSIDE_CASTLING_INPUT]

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
      puts "Please enter a correctly formatted move (ex: b3 b6, 0-0 to castle kingside, 0-0-0 to castle queenside), or b4 c3 e.p. to perform en_passant:"
      user_move_input
    end
  end

  def piece_promotion_input
    input = user_input
    if VALID_REPLACEMENT_EXPRESSIONS.any? { |expression| input.capitalize =~ expression }
      input.capitalize
    else
      puts "Please enter a valid replacement piece (Queen, Rook, Bishop, Knight)"
      piece_promotion_input
    end
  end

  private

  def user_input
    print "> "
    gets.chomp
  end
end