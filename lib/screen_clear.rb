class ScreenClear

  def self.clear_screen!
    print "\e[H\e[2J"
  end

end