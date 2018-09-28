require 'Concurrent'

class Road
  DIRECTIONS =  {no_car: 0, east: 1, west: 2}
  RANGE_ONE_WAY = [5,10]
  FULL_LENGTH = 14.freeze

  attr_reader :direction, :cars

  def initialize(direction)
    @direction = direction
    @cars = [] #make a new list
  end

  def insert_car(car) #insert the new car to the head
    @cars.unshift car
  end

  def remove_car(car)
    @cars.delete car
  end

  def get_next_car(car)
    i = @cars.index(car)
    if i == nil
      nil
    else
      @cars[i+1]
    end
  end

  def dist_btw_two_cars(car1, car2)
    if car1 == nil or car2 == nil
      0
    else
      (car1.x_pos - car2.x_pos).abs
    end
  end

end

#shared resources by all cars (threads)
module OneWayLane
  MAX_CAPACITY = 5

  @@west_one_way = Mutex.new
  @@east_one_way = Mutex.new
  @@capacity_one_way = Concurrent::Semaphore.new(MAX_CAPACITY)
  @@direction_one_way = Road::DIRECTIONS[:no_car] #need ReadWriteLock
end
