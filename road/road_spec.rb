require_relative 'road'

describe Road do
  NUM_OF_CARS = 3
  let(:west_road){Road.new(WEST)}

  before(:each) do
    (1..NUM_OF_CARS).each do |i|
      car = double('car', x_pos: i)
      west_road.insert_car(car)
    end
  end

  it ".initialize" do
    expect(west_road.direction).to eq WEST
    expect(west_road.cars.length).to be NUM_OF_CARS
  end

  it ".insert_car" do
    car = double('car')
    expect{west_road.insert_car(car)}.to change{west_road.cars.length}.by(1)
  end

  it ".remove_car" do
    expect{west_road.remove_car(west_road.cars.last)}.to change{west_road.cars.length}.by(-1)
  end

  describe '.dist_btw_next_car' do
    let(:first_car){west_road.cars.first}
    let(:last_car){west_road.cars.last}

    it "returns correct distance if there is a next car" do
      expect(west_road.dist_btw_next_car(first_car)).to eq 1
    end

    it "returns NO_NEXT_CAR if there is no next car" do
      expect(west_road.dist_btw_next_car(last_car)).to eq Road::NO_NEXT_CAR
    end

    it "raise ArgumentError if current car is not found" do
      expect{west_road.dist_btw_next_car('cannot find it')}.to raise_error ArgumentError
    end
  end
end
