require_relative 'car'

describe Car do
  let(:west_road){Road.new(Road::DIRECTIONS[:west])}
  let(:west_car){Car.new(west_road)}
  let(:east_road){Road.new(Road::DIRECTIONS[:east])}
  let(:east_car){Car.new(east_road)}

  describe "#new" do
    it {expect(east_car.x_pos).to eq 0}
    it {expect(west_car.x_pos).to eq Road::FULL_LENGTH}
  end

  describe "#move_a_unit" do
    it "eastbound car increases x_pos by ONE_UNIT" do
      east_road.insert_car(east_car)
      expect{east_car.move}.to change{east_car.x_pos}.by Car::ONE_UNIT
    end

    it "westbound car decreases x_pos by ONE_UNIT" do
      west_road.insert_car(west_car)
      expect{west_car.move}.to change{west_car.x_pos}.by -(Car::ONE_UNIT)
    end

    it "A car cannot pass its next car" do
      next_east_car = double("Car", x_pos: 1, direction: Road::DIRECTIONS[:east])
      east_road.insert_car(next_east_car)
      east_road.insert_car(east_car)
      expect{east_car.move}.to change{east_car.x_pos}.by 0
    end
  end

  describe 'An east_car enter one way lane with' do
    before(:each) do
      OneWayLane.init_shared_variables
      allow(east_car).to receive(:x_pos){Road::RANGE_ONE_WAY[0] - Car::ONE_UNIT}
      allow(west_car).to receive(:x_pos){Road::RANGE_ONE_WAY[1] + Car::ONE_UNIT}
    end
    it 'no car' do
      east_car.move
      expect(OneWayLane.direction_one_way).to eq Road::DIRECTIONS[:east]
      expect(OneWayLane.east_one_way.locked?).to eq true
      expect(OneWayLane.capacity_one_way.available_permits) to eq (OneWayLane::MAX_CAPACITY-1)
    end

    it 'one car in same direction' do
      east_car.move
      expect(OneWayLane.direction_one_way).to eq Road::DIRECTIONS[:east]
      expect(OneWayLane.east_one_way.locked?).to eq true
      expect(OneWayLane.capacity_one_way.available_permits) to eq (OneWayLane::MAX_CAPACITY - 2)
    end

    it 'one car in different direction' do
      west_car.move
      east_car.move
      expect(OneWayLane.direction_one_way).to eq Road::DIRECTIONS[:west]
      expect(OneWayLane.east_one_way.locked?).to eq false
      expect(OneWayLane.west_one_way.locked?).to eq true
      expect(OneWayLane.capacity_one_way.available_permits) to eq (OneWayLane::MAX_CAPACITY - 1)
    end
  end

  describe 'An east_car leave one way lane with' do

  end

  describe "when west and east cars are to enter enter_one_way_lane" do

  end

end
