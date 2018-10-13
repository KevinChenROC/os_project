require_relative '../road/road.rb'

MAX_NUM_CARS = 9;
MAKE_CAR_INTERVAL = (1 .. 1.5)
MOVE_CAR_INTERVAL = (0.7 .. 1.1)

class CarMaker
  @@prng = Random.new

  def self.new_car_maker_daemon!(roads)
    Thread.new do
      while(true) do
        CarMaker.make_an_car_thread!(roads)
        sleep @@prng.rand(MAKE_CAR_INTERVAL)
      end
    end
  end

  private
  def self.make_an_car_thread!(roads)
    @@prng.rand(2) == 0 ? make_car_thread_for!(roads[WEST]) : make_car_thread_for!(roads[EAST])
  end

  def self.make_car_thread_for!(road)
    t = Thread.new do
      car = Car.new(road)
      road.insert_car car
      until car.at_the_end_of_road?
        car.move!
        sleep @@prng.rand(MAKE_CAR_INTERVAL)
      end
      road.remove_car car
    end
    t.run
  end

end
