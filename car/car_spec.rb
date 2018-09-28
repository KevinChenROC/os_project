require_relative 'car'

describe Car do
  let(:west_road){Road.new(Road::DIRECTIONS[:west])}
  let(:west_car){Car.new(west_road)}
  let(:east_road){Road.new(Road::DIRECTIONS[:east])}
  let(:east_car){Car.new(east_road)}

  describe ".new" do
    it {expect(east_car.x_pos).to eq 0}
    it {expect(west_car.x_pos).to eq Road::FULL_LENGTH}
  end

  describe ".move_a_unit" do
    it "eastbound car increases x_pos by ONE_UNIT" do
      expect{east_car.move}.to change{east_car.x_pos}.by Car::ONE_UNIT
    end

    it "westbound car decreases x_pos by ONE_UNIT" do
      expect{west_car.move}.to change{west_car.x_pos}.by -(Car::ONE_UNIT)
    end

    it "A car cannot pass its next car" do
      next_east_car = double("Car", x_pos: 1, direction: Road::DIRECTIONS[:east])
      east_road.insert_car(next_east_car)
      east_road.insert_car(east_car)
      expect{east_car.move}.to change{east_car.x_pos}.by 0
    end
  end

  describe '.enter_one_way_lane' do

  end

  describe '.leave_one_way_lane' do

  end

  describe "when west and east cars are to enter enter_one_way_lane" do

  end

end
