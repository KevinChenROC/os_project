require_relative "setting.rb"

module DrawRoadUtil
  def self.draw_upper_line!(gc,area)
    points =  [
      [Setting::UP_LINE_X, Setting::UP_LINE_Y],
      [Setting::LANE_UPLINE_X1, Setting::UP_LINE_Y],
      [Setting::LANE_UPLINE_X1, Setting::LANE_UPLINE_Y],
      [Setting::LANE_UPLINE_X2, Setting::LANE_UPLINE_Y],
      [Setting::LANE_UPLINE_X2, Setting::UP_LINE_Y],
      [Setting::LANE_UPLINE_X2 + Setting::ROAD_W,Setting::UP_LINE_Y]
    ]

    area.window.draw_lines(gc, points)
  end

  def self.draw_mid_line!(gc,area)
    x2 = Setting::UP_LINE_X+Setting::ROAD_W-Setting::CAR_FULL_W
    x3 = Setting::UP_LINE_X + Setting::CAR_FULL_W +
    (Road::FULL_LENGTH - Road::RANGE_ONE_WAY[0]) * Setting::CAR_FULL_W


    points=[
      [Setting::UP_LINE_X,Setting::MID_LINE_Y],
      [x2,Setting::MID_LINE_Y],
    ]
    area.window.draw_lines(gc, points)

    points = [
      [x3, Setting::MID_LINE_Y],
      [x3+Setting::ROAD_W-Setting::CAR_FULL_W, Setting::MID_LINE_Y]
    ]

    area.window.draw_lines(gc, points)
  end

  def self.draw_lower_line!(gc,area)

    points = [
      [Setting::UP_LINE_X, Setting::LOW_LINE_Y],
      [Setting::LANE_UPLINE_X1, Setting::LOW_LINE_Y],
      [Setting::LANE_UPLINE_X1, Setting::LANE_LOW_LINE_Y],
      [Setting::LANE_UPLINE_X2, Setting::LANE_LOW_LINE_Y],
      [Setting::LANE_UPLINE_X2, Setting::LOW_LINE_Y],
      [Setting::LANE_UPLINE_X2 + Setting::ROAD_W,Setting::LOW_LINE_Y]
    ]

    area.window.draw_lines(gc, points)
  end

end
