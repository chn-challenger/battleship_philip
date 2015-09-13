# require_relative 'board'

class Ship

  attr_reader :size, :body

  def initialize(size=2)
    @size = size
    @body = []
    @size.times do
      @body << {grid_coords:[], hit:false}
    end
    @sunk = false
  end

  def sunk
    body.each do |part|
      if part[:hit] == false
        @sunk = false
        return @sunk
      end
    end
    @sunk = true
    return @sunk
  end 
end

p ship1 = Ship.new(4)



