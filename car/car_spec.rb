require_relative 'car'

describe Car do
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

    it 'east_car moves to the end' do
      Road::FULL_LENGTH.times {east_car.move!}
      expect(east_car.at_the_end_of_road?).to eq true
    end

    it 'west_car moves to the end' do
      (3 + Road::FULL_LENGTH).times {west_car.move!}
      expect(west_car.at_the_end_of_road?).to eq true
    end
  end

  describe 'An east_car about to enter one way lane' do
    let(:west_car){Car.new(west_road, Road::RANGE_ONE_WAY[1] + Car::ONE_UNIT)}
    let(:east_car){Car.new(east_road,Road::RANGE_ONE_WAY[0] - Car::ONE_UNIT)}

    it '#about_to_enter_lane?' do
      expect(east_car).to receive :enter_lane!
      expect(west_car).to receive :enter_lane!
      east_car.move!
      west_car.move!
    end

    it 'with no car in the lane' do
      east_car.move!
      expect(OneWayLane.direction_one_way).to eq EAST
      expect(OneWayLane.direction_locked?).to eq true
      expect(OneWayLane.capacity_one_way.available_permits).to eq (OneWayLane::MAX_CAPACITY-1)
      expect(east_car.x_pos).to be >= Road::RANGE_ONE_WAY[0]
      expect(east_car.x_pos).to be <= Road::RANGE_ONE_WAY[1]
    end

    it 'with one west_car about to enter at the same time' do
      t1 = Thread.new do
        east_car.move!
        expect(OneWayLane.direction_one_way).not_to eq NO_CAR
        expect(OneWayLane.direction_locked?).to eq true
        expect(OneWayLane.capacity_one_way.available_permits).to eq (OneWayLane::MAX_CAPACITY - 1)
        if OneWayLane.direction_one_way == EAST
          expect(east_car.x_pos).to be >= Road::RANGE_ONE_WAY[0]
        else
          expect(west_car.x_pos).to be <= Road::RANGE_ONE_WAY[1]
        end
      end
      t2 = Thread.new{2.times{west_car.move!}}

      t1.join(0.5)
      t2.join(0.5)
    end

    it 'with MAX_CAPACITY eastbound cars in the lane' do
      OneWayLane.init_shared_variables
      east_road.remove_car east_car #because it's the leftmost car
      car_to_enter = east_car
      threads = []

      OneWayLane.direction_one_way = EAST
      OneWayLane.direction_mutex.acquire
      (1..OneWayLane::MAX_CAPACITY).each do |i|
        car = Car.new(east_road, Road::RANGE_ONE_WAY[1] - i*Car::ONE_UNIT)
        east_road.insert_car car
        OneWayLane.capacity_one_way.acquire
      end
      expect(OneWayLane.capacity_one_way.available_permits).not_to eq OneWayLane::MAX_CAPACITY

      east_road.insert_car car_to_enter
      east_road.cars.each do |car|
        t = Thread.new do
          until car.at_the_end_of_road?
            car.move!
          end
          east_road.remove_car car
        end
        threads << t
      end

      threads.each &:join
      expect(east_road.cars.length).to eq 0

    end

    it "with MAX_CAPACITY westbound cars in the lane " do
      OneWayLane.init_shared_variables
      threads = []

      OneWayLane.direction_one_way = WEST
      OneWayLane.direction_mutex.acquire
      (1..OneWayLane::MAX_CAPACITY).each do |i|
        car = Car.new(west_road, Road::RANGE_ONE_WAY[0] + i*Car::ONE_UNIT)
        west_road.insert_car car
        OneWayLane.capacity_one_way.acquire
      end
      expect(OneWayLane.capacity_one_way.available_permits).to_not eq OneWayLane::MAX_CAPACITY

      ##bind each westcar to a thread
      west_road.cars.each do |car|
        t = Thread.new do
          car.move! until car.at_the_end_of_road?
          west_road.remove_car car
        end
        threads << t
      end

      threads << Thread.new{east_car.move! until east_car.at_the_end_of_road?}
      threads.each &:join

      expect(east_car.x_pos).to be > Road::RANGE_ONE_WAY[1]
      expect(west_road.cars.length).to eq 0
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

    it 'one east_car in the lane' do
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
      t_east_car = Thread.new{5.times{east_car.move!}}
      t_west_car = Thread.new do
        3.times{west_car.move!}
        expect(OneWayLane.direction_one_way).to eq WEST
        expect(OneWayLane.direction_locked?).to eq true
        expect(OneWayLane.capacity_one_way.available_permits).to eq (OneWayLane::MAX_CAPACITY - 1)

        expect(east_car.x_pos).to be >= Road::RANGE_ONE_WAY[1]
        expect(west_car.x_pos).to be <= Road::RANGE_ONE_WAY[1]
      end
      t_west_car.join
      t_east_car.join
    end

    it 'another east car about to enter' do
      car_to_enter = Car.new(east_road, Road::RANGE_ONE_WAY[0] - Car::ONE_UNIT)
      east_road.insert_car car_to_enter
      expected_range = ((OneWayLane::MAX_CAPACITY - 2)..(OneWayLane::MAX_CAPACITY - 1))

      thr_car_to_enter = Thread.new do
        car_to_enter.move! until car_to_enter.x_pos > Road::RANGE_ONE_WAY[0]

        expect(OneWayLane.direction_one_way).to eq EAST
        expect(expected_range).to cover OneWayLane.capacity_one_way.available_permits
        expect(car_to_enter.x_pos).to be >= Road::RANGE_ONE_WAY[0]
        expect(OneWayLane.direction_locked?).to eq true
      end
      thr_car_to_leave = Thread.new{ 5.times{east_car.move!}}

      thr_car_to_leave.join
      thr_car_to_enter.join

      expect(east_car.x_pos).to be > Road::RANGE_ONE_WAY[1]
    end

  end

##
end
