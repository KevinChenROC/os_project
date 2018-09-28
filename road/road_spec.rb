require_relative 'road'

describe Road do
  NUM_OF_CARS = 3
  let(:west_road){Road.new(Road::DIRECTIONS[:west])}

  before(:each) do
    (1..NUM_OF_CARS).each do
      car = double('car')
      west_road.insert_car(car)
    end
  end

  it ".initialize" do
    expect(west_road.direction).to eq Road::DIRECTIONS[:west]
    expect(west_road.cars.length).to be NUM_OF_CARS
  end

  it ".insert_car" do
    car = double('car')
    expect{west_road.insert_car(car)}.to change{west_road.cars.length}.by(1)
  end

  it ".remove_car" do
    expect{west_road.remove_car(west_road.cars.last)}.to change{west_road.cars.length}.by(-1)
  end

  describe '.dist_btw_two_cars' do
    it "there are two cars" do
      car1 = double('car1', x_pos: 2)
      car2 = double('car2', x_pos: 5)
      expect(west_road.dist_btw_two_cars(car1, car2)).to eq 3
      expect(west_road.dist_btw_two_cars(car2, car1)).to eq 3
    end

    it "there are 0 or 1 cars" do
      car1 = double('Car', x_pos: 2)
      expect(west_road.dist_btw_two_cars(car1, nil)).to eq 0
      expect(west_road.dist_btw_two_cars(nil, nil)).to eq 0
    end
  end

  it ".get_next_car" do
    cars = west_road.cars
    first_car = cars.first
    last_car = cars.last

    expect(west_road.get_next_car(last_car)).to eq nil
    expect(west_road.get_next_car(first_car)).to eq west_road.cars[1]
    expect(west_road.get_next_car('Cannot find this car')).to eq nil
  end

end
