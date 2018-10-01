require 'Concurrent'

class Road
  DIRECTIONS =  {no_car: 'no_car', east: 'east', west: 'west'}
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
      raise ArgumentError, "Car NOT Found"
    else
      @cars[i+1]
    end
  end
end

class OneWayLane
  MAX_CAPACITY = 5
  class << self
    attr_accessor :west_one_way, :east_one_way, :capacity_one_way, :direction_one_way

    #instance variabes for self object, which is 'OneWayLane' class object
    def init_shared_variables
      @west_one_way = Mutex.new
      @east_one_way = Mutex.new
      @capacity_one_way = Concurrent::Semaphore.new(MAX_CAPACITY)
      @direction_one_way = Road::DIRECTIONS[:no_car] #need ReadWriteLock
    end
  end
end
