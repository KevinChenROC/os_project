require_relative '../road/road.rb'

class Car
  ONE_UNIT = 1
  TIME_TO_WAIT_NEXT_CAR = 0.2
  @@lock = Concurrent::ReentrantReadWriteLock.new
  @@id_count = 1

  attr_reader :x_pos, :direction, :id

  def initialize(road, x_pos=nil)
    @road = road #the road where the car moves
    @direction = road.direction
    @id = @@id_count
    @@id_count += 1

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

  #NOTE A car can't pass its next car. Return if dist is too close
  def move!
    return if @road.dist_btw_next_car(self) <= ONE_UNIT

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

  def in_one_way_lane?
    (@x_pos >= Road::RANGE_ONE_WAY[0] && @x_pos <= Road::RANGE_ONE_WAY[1]) ? true : false
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
    if @direction == WEST
      @x_pos -= ONE_UNIT
    elsif @direction == EAST
      @x_pos += ONE_UNIT
    else
      raise NameError, "#move_a_unit!: Invalid Direction"
    end
  end

  def enter_lane!
    set_lane_direction_with_lock

    if OneWayLane.direction_one_way == @direction
      if OneWayLane.direction_locked?
        # DEBUG:
        # puts "before acquire..."
        OneWayLane.capacity_one_way.acquire
        move_a_unit!
      end
    end

    if OneWayLane.direction_one_way != @direction && OneWayLane.direction_one_way != NO_CAR
      wait_for_the_other_direction
    end
  end

  def leave_lane!
    move_a_unit!
    @@lock.with_write_lock{OneWayLane.capacity_one_way.release}
    reset_lane_direction_with_lock
  end

  def set_lane_direction_with_lock
    @@lock.with_write_lock do
      if OneWayLane.direction_one_way == NO_CAR && OneWayLane.capacity_one_way.available_permits >= OneWayLane::MAX_CAPACITY
        OneWayLane.direction_one_way = @direction
      end
      OneWayLane.direction_mutex.acquire if OneWayLane.direction_locked? == false
    end
  end

  def reset_lane_direction_with_lock
    @@lock.with_write_lock do
      if (OneWayLane.direction_one_way != NO_CAR) && (OneWayLane.capacity_one_way.available_permits == OneWayLane::MAX_CAPACITY)
        OneWayLane.direction_one_way = NO_CAR
        OneWayLane.direction_mutex.release until OneWayLane.direction_locked? == false
      end
    end
  end

  def wait_for_the_other_direction
    OneWayLane.direction_mutex.acquire
  end
end
