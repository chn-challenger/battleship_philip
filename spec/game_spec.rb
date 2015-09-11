require 'game'


describe Game do
 it 'should initialize a new game' do
   expect(subject.class).to eql(Game)

 end

 it {expect(subject).to respond_to(:setup_board)}

 describe '#read boards' do

   it {expect(subject).to respond_to(:boards)}

 end

  describe '#setup board' do

   it 'creates a new board' do
    game1 = Game.new
    expect(game1.boards).to eq([])
    game1.setup_board
    expect(game1.boards.count).to eq 1
    expect(game1.boards[0].class).to eq(Board)
   end
  end

  describe '#user_place_ship' do
    it 'prompts the user and saves the output' do

    end
    it 'feeds the user output into place_ship method of board and places ship' do

    end
    it 'reprompts the user for new position if '

  end













end
