require_relative 'board'

class Game
  attr_accessor :board_size, :boards, :ships

  def initialize(board_size, player1_name, player2_name, array_of_ship_sizes)
    @player1_name = player1_name
    @player2_name = player2_name
    @board_size = board_size
    @boards = {}
    @boards[@player1_name] = Board.new(board_size,player1_name)
    @boards[@player2_name] = Board.new(board_size,player2_name)
    @ships_player1 = []
    array_of_ship_sizes.each do |ship_size|
        @ships_player1 << Ship.new(ship_size)
    end
    @ships_player2 = []
    array_of_ship_sizes.each do |ship_size|
        @ships_player2 << Ship.new(ship_size)
    end
  end

  def run
    setup_board(@boards[@player1_name], @player1_name, @ships_player1)
    puts 'Press any key to end deployment, then please ask your opponent to take the hotseat and deploy ships.  '
    gets
    space_lines(3000)
    setup_board(@boards[@player2_name], @player2_name, @ships_player2)
    puts 'Press any key to end deployment, then please ask your opponent to take the hotseat and start the game!  '
    gets
    space_lines(3000)
    # p @boards
    while true
      player_turn(@boards[@player1_name],@boards[@player2_name], @player1_name)
      player2_lost = @boards[@player2_name].loose?
      if player2_lost
          @boards[@player2_name].show_opponent_board
          space_lines(2)
          puts 'Congratulations '+ @player1_name + '!!!! You have won!!!' 
          space_lines(2)
          puts 'Press any key to end game'
          gets
          return nil
      end
      player_turn(@boards[@player2_name],@boards[@player1_name], @player2_name)
      player1_lost = @boards[@player1_name].loose?
      if player1_lost
          @boards[@player1_name].show_opponent_board
          space_lines(2)
          puts 'Congratulations '+ @player2_name + '!!!! You have won!!!' 
          space_lines(2)
          puts 'Press any key to end game'
          gets
          return nil
      end
    end
      # player_turn(@boards[0],@boards[1], @player1_name)
      # player_turn(@boards[1],@boards[0], @player2_name)
      # player_turn(@board[0],@board[1], @player1_name)
      # player_turn(@board[1],@board[0], @player2_name)
      # player_turn(@board[0],@board[1], @player1_name)
      # player_turn(@board[1],@board[0], @player2_name)
    
  end

  def player_turn(my_board, opponent_board, my_name)    
    puts 'Player ' + my_name + '  Press any key to start your turn'
    any_key = gets
    puts 'Player  ' + my_name + "'s board"
    puts ''
    my_board.show_my_board
    puts ''
    puts "Opponent's board"
    puts ''
    opponent_board.show_opponent_board
    puts ''
    puts 'Player  ' + my_name + '  Please enter your position to fire at opponents ships in "x,y" format.'
    puts ''
    user_input = gets.chomp

    #neeed sanitize!!!!!!!!

    user_input = user_input.split(',')
    user_input = [user_input[0].to_i,user_input[1].to_i]
    opponent_board.fire_missile(user_input[0],user_input[1])
    puts ''
    puts "Opponent's board after firing the missile"
    puts ''
    opponent_board.show_opponent_board
    puts ''    
    puts my_name + '  Press any key to end your turn, and ask your opponent to take the hotseat'
    any_key = gets
    space_lines(200)
  end


  def setup_board(board, player_name, ships)
    title_lines(player_name)
    space_lines(2)
    ship_placement_instructions(player_name)
    space_lines(2)
    board.show_my_board
    space_lines(2)

    ships.each do |ship|
      user_input(board, ship)
      space_lines(2)
      board.show_my_board
      space_lines(2)
    end
    puts 'End of ship deplyment'
    space_lines(2)
    return nil
  end


  def title_lines(name)
    return 'name must be string' if name.is_a?(String) == false
    2.times{puts ''}
    puts "  "*30 + 'Player  '+name+"'s turn"
    2.times{puts ''}
  end

  def ship_placement_instructions(name)
    puts 'Player ' + name + ' please take the hotseat to place ships.  When ready, please enter the position of your ship.'
    puts "Position must be in format: [x,y,orientation], for example [0,1,south] or [2,4,north]."
    puts "Orientation must be one of ['north','south','east','west']"
    puts "Your ship will be placed with bowle at [x,y], head facing the orientation of your choice."
  end

  def user_input(board, ship)
    user_input = gets.chomp
    sanitized_user_input = sanitize_user_position(user_input)
    if sanitized_user_input == 'try again'
      puts ''
      puts 'invalid input please try again'
      puts ''
      user_input(board, ship)
    else
      place_ship_return = board.place_ship(ship,sanitized_user_input[0],sanitized_user_input[1],sanitized_user_input[2])
      if place_ship_return == 'outside range'
        puts ''
        puts 'Position entered is out of board range, please try again.'
        puts ''
        user_input(board,ship)
      end
      if place_ship_return == 'overlapping'
        puts ''
        puts 'Position entered is overlapping, please try again.'
        puts ''
        user_input(board,ship)
      end
    end
    return nil
  end

  def space_lines(n)
    n.times{puts ''}
  end

  def sanitize_user_position(position)
    orientations = ['north','south','east','west']
    return 'try again' if position.is_a?(String) == false
    position.gsub!(' ','')
    position.delete!('[')
    position.delete!(']')
    position = position.split(',')
    return 'try again' if position.length != 3
    return 'try again' if position[0].respond_to?('to_i') == false || position[1].respond_to?('to_i') == false
    return 'try again' if orientations.include?(position[2].downcase) == false
    return [position[0].to_i,position[1].to_i,position[2].downcase]
  end

end


def test
game1 = Game.new
# game1.title_lines('Joe')
# game1.ship_placement_instructions('Joe')
game1.setup_board(6,'Joe')
end


# game2 = Game.new
# ships = [Ship.new(3),Ship.new(2),Ship.new(3)]
# # game2.setup_board(6,'Joe',ships)

game1 = Game.new(6, 'Joe', 'Lulu', [2,3])
game1.run

# a = '2,3'
# a = a.split(',')
# a = [a[0].to_i,a[1].to_i]
# p a








    # while true
    #   input = user_input
    #   result = sanitize_user_position(input)

    #   if result != 'try again'
    #     p result
    #     break
    #   end
    #   puts ''
    #   puts 'Invalid position, try again'
    #   puts ''
    # end



    # space_lines 2
    # puts "THANK YOU!!!!"


    # ship = Ship.new(3)
    # board.place_ship(ship,result[0],result[1],result[2])
    # board.show_my_board




    # title_lines(name)
    # space_lines(2)
    # ship_placement_instructions(name)
    # space_lines(2)
    
    # while true
    #   input = user_input
    #   result = sanitize_user_position(input)

    #   if result != 'try again'
    #     p result
    #     break
    #   end
    #   puts ''
    #   puts 'Invalid position, try again'
    #   puts ''
    # end



    # space_lines 2
    # puts "THANK YOU!!!!"


    # ship = Ship.new(3)
    # board.place_ship(ship,result[0],result[1],result[2])
    # board.show_my_board








#  board1 = Board.new
#  p board1
# ship = Ship.new
# p ship# game1=Game.new
#
# # p game1.setup_board
# game1=Game.new
# p 'hello'
# game1.space_lines(10)
# p 'world'


# def player_place_ship(position)
#   orientations = ['north','south','east','west']
#   return 'try again' if position.is_a?(String) == false
#   position.gsub!(' ','')
#   position.delete!('[')
#   position.delete!(']')
#   position = position.split(',')
#   return 'try again' if position.length != 3
#   p position
#   return 'try again' if position[0].respond_to?('to_i') == false || position[1].respond_to?('to_i') == false
#   p position
#   return 'try again' if orientations.include?(position[2].downcase) == false
#   return [position[0].to_i,position[1].to_i,position[2].downcase]
# end


# p player_place_ship('[1,2,south]')

# puts " "*20 + 'Player A' + " "*20
