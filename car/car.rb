require_relative '../road/road.rb'

class Car
  ONE_UNIT = 1

  attr_reader :x_pos, :direction

  def initialize(road)
    @road = road #the road where the car moves
    @direction = road.direction

    if @direction == Road::DIRECTIONS[:west]
      @x_pos = Road::FULL_LENGTH
    elsif @direction == Road::DIRECTIONS[:east]
      @x_pos = 0
    else
      raise "Invalid Direction"
    end
  end

  def move
    move_a_unit
    #if about to enter
    #enter one way
    #else if about to leave
    # leave one way
    # else move a unit
  end

  private
  def move_a_unit
    return if @road.dist_btw_next_car(self) <= ONE_UNIT

    if @direction == Road::DIRECTIONS[:west]
      @x_pos -= ONE_UNIT
    elsif @direction == Road::DIRECTIONS[:east]
      @x_pos += ONE_UNIT
    else
      raise NameError, "Invalid Direction"
    end
  end

  def enter_one_way_lane
  end

  def leave_one_way_lane
  end
end
