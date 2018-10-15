require_relative '../road/road.rb'

MAX_NUM_CARS = 9;
MAKE_CAR_INTERVAL = (1 .. 3)
MOVE_CAR_FACTOR = 0.3

class CarMaker

  def self.new_car_maker_daemon!(roads)
    @@prng = Random.new
    @@num_car = 0
    Thread.new do
      while(true) do
        CarMaker.make_an_car_thread!(roads)
        sleep @@prng.rand(MAKE_CAR_INTERVAL)
      end
    end
  end

  private
  def self.make_an_car_thread!(roads)
    if @@num_car < MAX_NUM_CARS
      @@num_car += 1
      @@prng.rand(2) == 0 ? make_car_thread_for!(roads[WEST]) : make_car_thread_for!(roads[EAST])
    end
  end

  def self.make_car_thread_for!(road)
    t = Thread.new do
      car = Car.new(road)
      road.insert_car car
      until car.at_the_end_of_road?
        car.move!
        sleep (@@prng.rand(MAKE_CAR_INTERVAL) * MOVE_CAR_FACTOR)
      end
      road.remove_car car
      @@num_car -= 1
    end
    t.run
  end

end
