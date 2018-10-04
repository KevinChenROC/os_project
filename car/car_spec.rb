require_relative 'car'

describe do
  let(:west_road){Road.new(WEST)}
  let(:west_car){Car.new(west_road)}
  let(:east_road){Road.new(EAST)}
  let(:east_car){Car.new(east_road)}

  before(:each) do
    west_road.insert_car west_car
    east_road.insert_car east_car
    OneWayLane.init_shared_variables
  end

  describe "#new" do
    it {expect(east_car.x_pos).to eq 0}
    it {expect(west_car.x_pos).to eq Road::FULL_LENGTH}
    it {expect(west_car.direction).to eq WEST}
    it {expect(east_car.direction).to eq EAST}
  end

  describe "#move_a_unit!" do
    it "eastbound car increases x_pos by ONE_UNIT" do
      expect{east_car.move!}.to change{east_car.x_pos}.by Car::ONE_UNIT
    end

    it "westbound car decreases x_pos by ONE_UNIT" do
      expect{west_car.move!}.to change{west_car.x_pos}.by -(Car::ONE_UNIT)
    end

    it "A car cannot pass its next car" do
      next_east_car = double("Car", x_pos: 1, direction: EAST)
      east_road.insert_car(next_east_car)
      east_road.insert_car(east_car)
      expect{east_car.move!}.to change{east_car.x_pos}.by 0
    end
  end

  describe "#at_the_end_of_road?" do
    let(:west_car){Car.new(west_road, 0)}
    let(:east_car){Car.new(east_road, Road::FULL_LENGTH)}

    it{expect(east_car.at_the_end_of_road?).to eq true}
    it{expect(west_car.at_the_end_of_road?).to eq true}
  end

  describe 'An east_car enter one way lane' do
    let(:west_car){Car.new(west_road, Road::RANGE_ONE_WAY[1] + Car::ONE_UNIT)}
    let(:east_car){Car.new(east_road,Road::RANGE_ONE_WAY[0] - Car::ONE_UNIT)}

    it '#about_to_enter_lane?' do
      expect(east_car).to receive :enter_lane!
      expect(west_car).to receive :enter_lane!
      east_car.move!
      west_car.move!
    end

    it 'no car' do
      east_car.move!
      expect(OneWayLane.direction_one_way).to eq EAST
      expect(OneWayLane.direction_locked?).to eq true
      expect(OneWayLane.capacity_one_way.available_permits).to eq (OneWayLane::MAX_CAPACITY-1)
      expect(east_car.x_pos).to be >= Road::RANGE_ONE_WAY[0]
      expect(east_car.x_pos).to be <= Road::RANGE_ONE_WAY[1]
    end

    it 'with west_car about to enter at the same time' do
      expect(OneWayLane.direction_one_way).to eq NO_CAR

      east_car.move!
      t = Thread.new{west_car.move!}
      t.join(0.5) #t will be blocked, so set a limit
      expect(t.status).to eq 'sleep'

      expect(OneWayLane.direction_one_way).to eq EAST
      expect(OneWayLane.direction_locked?).to eq true
      expect(OneWayLane.capacity_one_way.available_permits).to eq (OneWayLane::MAX_CAPACITY - 1)
      expect(east_car.x_pos).to be >= Road::RANGE_ONE_WAY[0]
      expect(west_car.x_pos).to be > Road::RANGE_ONE_WAY[1]
    end
  end

  describe 'An east_car leaves one way lane with' do
    let(:east_car){Car.new(east_road,Road::RANGE_ONE_WAY[1] - Car::ONE_UNIT)}
    let(:west_car){Car.new(west_road,Road::RANGE_ONE_WAY[1] + Car::ONE_UNIT)}

    before do
      OneWayLane.direction_one_way = EAST
      OneWayLane.direction_mutex.acquire
      OneWayLane.capacity_one_way.acquire
    end

    it '#about_to_leave_lane?' do
      expect(east_car).to receive :leave_lane!
      east_car.move!
    end

    it 'no cars left' do
      east_car.move!

      expect(OneWayLane.direction_one_way).to eq NO_CAR
      expect(OneWayLane.direction_locked?).to eq false
      expect(OneWayLane.capacity_one_way.available_permits).to eq OneWayLane::MAX_CAPACITY
      expect(east_car.x_pos).to be >= Road::RANGE_ONE_WAY[1]
    end

    it 'one car left' do
      car = Car.new(east_road, Road::RANGE_ONE_WAY[0] - Car::ONE_UNIT)
      east_road.insert_car(car)
      car.move!
      east_car.move!

      expect(OneWayLane.direction_one_way).to eq EAST
      expect(OneWayLane.direction_locked?).to eq true
      expect(OneWayLane.capacity_one_way.available_permits).to eq (OneWayLane::MAX_CAPACITY - 1)
      expect(east_car.x_pos).to be >= Road::RANGE_ONE_WAY[1]
    end

    it 'one west_car about to enter' do
      t_east_car = Thread.new{east_car.move!;}
      t_west_car = Thread.new do
        2.times{west_car.move!}
        expect(OneWayLane.direction_one_way).to eq WEST
        expect(OneWayLane.direction_locked?).to eq true
        expect(OneWayLane.capacity_one_way.available_permits).to eq (OneWayLane::MAX_CAPACITY - 1)

        expect(east_car.x_pos).to be >= Road::RANGE_ONE_WAY[1]
        expect(west_car.x_pos).to be <= Road::RANGE_ONE_WAY[1]
      end
      t_west_car.join
      t_east_car.join
    end

    #TODO
    it 'another east car about to enter' do

    end

  end

end
