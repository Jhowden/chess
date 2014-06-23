class UserCommands

  def user_input
    print "> "
    gets.chomp
  end

  def user_team_input
    input = user_input
    if input.downcase == "white" || input.downcase == "black"
      input.downcase
    else
      puts "That is not a valid color. Please choose again (white or black):"
      user_team_input
    end
  end

  def user_move_input
    input = user_input
    if input =~ /^[a-h]{1}[1-8]{1}\s{1}[a-h]{1}[1-8]{1}/
      input
    else
      puts "Please enter a correctly formated move (ex: b3 b6):"
      user_move_input
    end
  end
end