require_relative "setting.rb"
require_relative "../road/road.rb"

module DrawCarUtil
  def self.draw_car!(gc, area,car)
    area.window.draw_rectangle(
      gc, true,
      get_srcx(car), get_srcy(car),
      Setting::CAR_W, Setting::CAR_W)
  end

  private
  def self.get_srcy(car)
    if car.in_one_way_lane?
      Setting::LANE_LOW_LINE_Y - Setting::CAR_FULL_W
    else
      if car.direction == EAST
        Setting::MID_LINE_Y - Setting::CAR_W
      elsif car.direction == WEST
        Setting::LOW_LINE_Y - Setting::CAR_W
      end
    end
  end

  def self.get_srcx(car)
    Setting::UP_LINE_X + (car.x_pos)* Setting::CAR_FULL_W - Setting::CAR_PADDING
  end

end
