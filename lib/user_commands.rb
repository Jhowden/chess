class UserCommands
  
  VALID_USER_INPUT = /^[a-h]{1}[1-8]{1}\s{1}[a-h]{1}[1-8]{1}/

  def user_input
    print "> "
    gets.chomp
  end

  def user_team_input
    input = user_input
    # ["white", "black"].any? {} instead of using the || in line 11
    if ["white", "black"].any? { |color| color == input.downcase}
      input.downcase
    else
      puts "That is not a valid color. Please choose again (white or black):"
      user_team_input
    end
  end

  def user_move_input
    input = user_input
    if input =~ VALID_USER_INPUT
      input
    else
      puts "Please enter a correctly formated move (ex: b3 b6):"
      user_move_input
    end
  end
end