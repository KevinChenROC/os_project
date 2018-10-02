require_relative '../road/road.rb'

class Car
  ONE_UNIT = 1
  @@lock = Concurrent::ReentrantReadWriteLock.new

  attr_reader :x_pos, :direction

  def initialize(road, x_pos=nil)
    @road = road #the road where the car moves
    @direction = road.direction

    if x_pos != nil
      @x_pos = x_pos
      return
    end

    if @direction == WEST
      @x_pos = Road::FULL_LENGTH
    elsif @direction == EAST
      @x_pos = 0
    else
      raise NameError, "Invalid Direction"
    end
  end

  def move!
    if about_to_enter_lane?
      enter_lane!
    elsif about_to_leave_lane?
      leave_lane!
    else
      move_a_unit!
    end
  end

  def at_the_end_of_road?
    if @direction == WEST
      @x_pos <= 0
    else
      @x_pos >= Road::FULL_LENGTH
    end
  end

  private
  def about_to_enter_lane?
    if @direction == EAST
      (Road::RANGE_ONE_WAY[0] - @x_pos) == ONE_UNIT ? true : false
    elsif @direction == WEST
      (@x_pos - Road::RANGE_ONE_WAY[1]) == ONE_UNIT ? true : false
    else
      raise NameError, "#about_to_enter_lane: Invalid direction"
    end
  end

  def about_to_leave_lane?
    if @direction == EAST
      (Road::RANGE_ONE_WAY[1] - @x_pos) == ONE_UNIT ? true : false
    elsif @direction == WEST
      (@x_pos - Road::RANGE_ONE_WAY[0]) == ONE_UNIT ? true : false
    else
      raise NameError, "#about_to_enter_lane: Invalid direction"
    end
  end

  def move_a_unit!
    return if @road.dist_btw_next_car(self) <= ONE_UNIT

    if @direction == WEST
      @x_pos -= ONE_UNIT
    elsif @direction == EAST
      @x_pos += ONE_UNIT
    else
      raise NameError, "#move_a_unit!: Invalid Direction"
    end
  end

  def set_new_lane_direction
    raise 'There are cars in the lane' unless OneWayLane.capacity_one_way.available_permits == OneWayLane::MAX_CAPACITY

    if OneWayLane.direction_one_way == NO_CAR
      set_lane_direction_with_lock(@direction)
      if OneWayLane.direction_mutex.available_permits == 1
        OneWayLane.direction_mutex.acquire
      end
    end
  end

  def enter_lane!
    set_new_lane_direction if OneWayLane.capacity_one_way.available_permits == OneWayLane::MAX_CAPACITY

    if OneWayLane.direction_one_way == @direction
      OneWayLane.capacity_one_way.acquire
      move_a_unit!
    else
      OneWayLane.direction_mutex.acquire
    end
  end

  def leave_lane!
    move_a_unit!
    OneWayLane.capacity_one_way.release

    #relase all shared resources
    if OneWayLane.capacity_one_way.available_permits == OneWayLane::MAX_CAPACITY
      set_lane_direction_with_lock NO_CAR
      OneWayLane.direction_mutex.release until OneWayLane.direction_mutex.available_permits == 1
    end
  end

  def set_lane_direction_with_lock(direction)
    @@lock.with_write_lock{OneWayLane.direction_one_way = direction}
  end
end
