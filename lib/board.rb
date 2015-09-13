require_relative 'ship'

class Board

  attr_reader :size, :name, :ships, :hits, :misses

  def initialize(size=10, name='')
    @size = size
    @name = name
    @ships = []
    @ship_coords = nil
    @hits = []
    @misses = []
    @name = ''
    @ocean =[] #generates an array of coordinates see board.ocean
    (0...size).each do |x|
      (0...size).each do |y|
        @ocean << [x,y]
      end
    end
  end

  def new_ship_coords(num,x_coord,y_coord,orientation) #this changes a number (of anything!), coordinates and orientation into an array that we can check
    results = []
    case orientation # take the orientation
    when 'south' #when orientattion is south
        num.times do #do this as many times as the size of the boat
        results << [x_coord,y_coord]# add the starting coordinate
        x_coord += 1 #add one to the x axis (so the boat goes south!)
        end
      when 'north'
        num.times do
        results << [x_coord,y_coord]
        x_coord -= 1 #so the boat goes north ....
        end
      when 'east'
        num.times do
        results << [x_coord,y_coord]
        y_coord += 1
        end
      when 'west'
        num.times do
        results << [x_coord,y_coord]
        y_coord -= 1
        end
    end
    results # returns the results array that we can now check against the ocean or boundary of the board
  end

  def outside?(ship, x_coord, y_coord, orientation) #this is a new ship ship = Ship.new - we are now doing board.place_ship(ship,2,3, "south")
    pending_coords = new_ship_coords(ship.size, x_coord, y_coord, orientation) #passsing all the variables through the new_ship_coords method - #
    #this is V important read this very carefull - what is being passed - where? - what is coming back - and notice carefully that we are calling the method
    #ship.size INSIDE the variable for the new_ship_cords method!!! This enables this bit of code to be free of outside concerns
    pending_coords.each do |xy_pair|
      return true if xy_pair.max >= size || xy_pair.min < 0 #logic flows in English - is ship outside?(method with ?) ? we always return true or false bu convention -
      # is ship outside? True - yes ship is outside - false - no it isn't
    end
    return false
  end

  def ship_coords
    @ship_coords = []
    @ships.each do |ship|
      ship.body.each do |hash|
        @ship_coords  << hash[:grid_coords]
      end
    end
    @ship_coords
  end

  def overlap?(ship, x_coord, y_coord, orientation)
    new_coords_to_add = new_ship_coords(ship.size, x_coord, y_coord, orientation)
    result  = new_coords_to_add & ship_coords
    if result == []
      return false
    else
      return true
    end
  end

  def place_ship(ship, x_coord, y_coord, orientation)
    return 'outside range' if outside?(ship, x_coord, y_coord, orientation)
    return 'overlapping' if overlap?(ship, x_coord, y_coord, orientation)
    new_choords = new_ship_coords(ship.size, x_coord, y_coord, orientation)
    (0...ship.size).each do |i|
      ship.body[i][:grid_coords] = new_choords[i] #here we are taking the index of the ship body array then we are setting the value of the body part
      #hash with the key :grid_cords to the value of the new_choords index -
    end
    @ships << ship
    return nil
  end

  def fire_missile(x_coord, y_coord)
    return 'outside range' if x_coord >= size || y_coord >= size || x_coord < 0 || y_coord < 0
    return 'already fired' if hits.include?([x_coord, y_coord]) || misses.include?([x_coord, y_coord])
      ships.each do |ship|
        ship.body.each do |part|
          if part[:grid_coords] == [x_coord, y_coord]
            part[:hit] = true #change the value of hit to true - :hit is the key for the hash body part and we are changing the value to true
            @hits << [x_coord, y_coord]
            puts 'Booooom!! What a hit!!'
            return 'hit'
          end
        end
      end
      @misses << [x_coord, y_coord] #if the loop runs with no hits we send the missle co-ord to the misses
      puts 'Shame you have missed!'
      return 'miss'
  end

  def ocean
    @ocean =[]
    (0...size).each do |x|
      (0...size).each do |y|
        @ocean << [x,y]
      end
    end
    @ocean = @ocean - ship_coords - @misses
    return @ocean
  end

  def show_my_board
    ship_not_hit = ship_coords - @hits  #returns just the parts of ship not hit - ie removes the hits!
    (0...size).each do |x| #for every row
      print '[ ' # create a start of the row
      (0...size).each do |y| # for each cell on each row
        current_coord = [x, y] # set coord to current_coord
        if @hits.include?(current_coord) #does the hits array contain the current_coord
          print 'Hit        ' #if it does print this
        elsif @misses.include?(current_coord)
          print 'Miss       '
        elsif ship_not_hit.include?(current_coord)
          print 'Ship       '
        elsif @ocean.include?(current_coord)
          print 'Ocean      '
        end
      end
      print ']'
      puts ''
    end
  end

  def show_opponent_board
    ship_not_hit = ship_coords - @hits
    blank = ocean + ship_not_hit

    (0...size).each do |x|
      print '[ '
      (0...size).each do |y|
        current_coord = [x, y]
        if @hits.include?(current_coord)
          print 'Hit        '
        elsif @misses.include?(current_coord)
          print 'Miss       '
        elsif blank.include?(current_coord)
          print 'Ocean      '
        end
      end
      print ']'
      puts ''
    end
  end

  def loose?
    @ships.each do |ship|
      if ship.sunk == false
        return false
      end
    end
    return true
  end

end



def scenario1
  board = Board.new(9)
  ship1 = Ship.new(3)
  ship2 = Ship.new(2)
  board.place_ship(ship1,0,1,'south')
  board.place_ship(ship2,2,2,'east')
  p board.fire_missile(1,1)
  p board.fire_missile(2,1)
  p board.fire_missile(3,1)
  p board.fire_missile(3,2)
  p board.fire_missile(1,2)
  p board.hits
  p board.misses
  p board.ship_coords - board.hits
  p board.ocean
  board.show_my_board
  # puts ''
  # puts ''
  # board.show_opponent_board

end

scenario1
