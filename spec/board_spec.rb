require 'board'

describe Board do
  describe '#initialize/new' do
    it 'when created has a default size of 10' do
      expect(subject.size).to eql(10)
    end
    it 'when created has a default empty ships array' do
      expect(subject.ships).to eql([])
    end
  end

  describe '#new_ship_coords' do
    it 'returns the correct coords when orientation is south' do
      board = Board.new
      expect(board.new_ship_coords(2,4,5,'south')).to eql([[4, 5], [5, 5]])
    end

    it 'returns the correct coords when orientation is north' do
      board = Board.new
      expect(board.new_ship_coords(2,3,6,'north')).to eql([[3, 6], [2, 6]])
    end

    it 'returns the correct coords when orientation is east' do
      board = Board.new
      expect(board.new_ship_coords(2,4,5,'east')).to eql([[4, 5], [4, 6]])
    end

    it 'returns the correct coords when orientation is west' do
      board = Board.new
      expect(board.new_ship_coords(2,2,3,'west')).to eql([[2, 3], [2, 2]])
    end
  end

  # describe '#outside?' do
  #   it 'raise error when asked to place a ship outside of grid range' do
  #     board = Board.new(6)
  #     ship1 = double(:ship_object)
  #     allow(ship1).to receive(:size).and_return(3)
  #     expect(board.outside?(ship1,4,2,'south')).to eql(true)
  #     expect(board.outside?(ship1,1,2,'north')).to eql(true)
  #     expect(board.outside?(ship1,4,1,'west')).to eql(true)
  #     expect(board.outside?(ship1,4,4,'east')).to eql(true)
  #   end
  # end

  describe '#place_ship' do
    it 'appends a ship to the ships array on the board' do
      ship1 = double(:ship)
      board1 = Board.new
      allow(ship1).to receive(:size).and_return(2)
      allow(ship1).to receive(:body).and_return([{:grid_coords => []},{:grid_coords => []}])
      board1.place_ship(ship1,2,3,'south')
      expect(board1.ships.first).to eql(ship1)
    end
  end

  describe '#current_ship_coords' do
    it "current_ship_coords" do
      ship1 = double(:ship1)
      ship2 = double(:ship2)
      allow(ship1).to receive(:body).and_return([{:grid_coords => [1,1]},{:grid_coords => [1,2]}])
      allow(ship2).to receive(:body).and_return([{:grid_coords => [2,3]},{:grid_coords => [2,4]}])
      class Board
        attr_accessor :ships
      end
      board1 = Board.new
      board1.ships << ship1
      board1.ships << ship2
      expect(board1.ship_coords).to eql([[1,1], [1,2], [2,3], [2,4]])
    end

    # it "should know when ships overlap" do
    #   ship1 = double(:ship1)
    #   ship2 = double(:ship2)
    #   ship3 = double(:ship3)
    #   allow(ship3).to receive(:size).and_return(3)
    #   allow(ship1).to receive(:body).and_return([{:grid_coords => [1,1]},{:grid_coords => [1,2]}])
    #   allow(ship2).to receive(:body).and_return([{:grid_coords => [2,3]},{:grid_coords => [2,4]}])
    #   class Board
    #     attr_accessor :ships
    #   end
    #   board1 = Board.new
    #   board1.ships << ship1
    #   board1.ships << ship2
    #   expect(board1.overlap?(ship3,0,1,'south')).to eql(true)
    # end
  end

  describe '#fire_missle' do
    it { expect(subject).to respond_to(:fire_missle).with(2).argument }
    it "can't fire missle outside range" do
      expect{subject.fire_missle(20,20)}.to raise_error "outside range"
    end
    it "can't fire if already fired at location" do
      subject.fire_missle(2,2)
      expect{subject.fire_missle(2,2)}.to raise_error "already fired at this location"
    end

    it "should register a miss" do
      subject.fire_missle(3,3)
      subject.fire_missle(2,2)
      expect(subject.misses).to eql([[3,3],[2,2]])
    end

    it 'should register a hit' do
        ship1 = double(:ship1)
        allow(ship1).to receive(:size).and_return(2)
        allow(ship1).to receive(:body).and_return([{:grid_coords => [1,1]},{:grid_coords => [1,2]}])
        subject.place_ship(ship1, 1, 1, 'south')
        subject.fire_missle(1,1)
        expect(subject.hits).to eql([[1,1]])
    end
  end

end
