require 'Concurrent'
NO_CAR = 'no car'
WEST = 'west'
EAST = 'east'

class Road
  RANGE_ONE_WAY = [5,10]
  FULL_LENGTH = 14.freeze
  NO_NEXT_CAR = FULL_LENGTH * 10

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

  def dist_btw_next_car(car)
    next_car = get_next_car(car)
    if next_car == nil
      NO_NEXT_CAR
    else
      (car.x_pos - next_car.x_pos).abs
    end
  end

  private
  def get_next_car(car)
    i = @cars.index(car)
    if i == nil
      raise ArgumentError, "#get_next_car: Car NOT FOUND"
    else
      @cars[i+1]
    end
  end
end

class OneWayLane
  MAX_CAPACITY = 5
  class << self
    attr_accessor :capacity_one_way, :direction_one_way, :direction_mutex

    def init_shared_variables
      @direction_mutex = Concurrent::Semaphore.new(1)
      @capacity_one_way = Concurrent::Semaphore.new(MAX_CAPACITY)
      @direction_one_way = NO_CAR #need ReadWriteLock
    end

    #TODO I need public api for direction_mutex and capacity_one_way to see their status
  end
end
