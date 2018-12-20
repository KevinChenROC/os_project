require_relative "../road/road.rb"

module Setting
  #Gtk::Window size
  WINDOW_WIDTH = 1000
  WINDOW_HEIGHT = 1000

  #CAR coordinates and size
  CAR_W = WINDOW_WIDTH / (Road::FULL_LENGTH * 2);
  CAR_PADDING = CAR_W / 3
  CAR_FULL_W = (CAR_W + CAR_PADDING)

  #Road coordinates and size
  ROAD_W = Road::RANGE_ONE_WAY[0] * CAR_FULL_W
  ROAD_H = CAR_FULL_W

  UP_LINE_X = CAR_FULL_W
  UP_LINE_Y = WINDOW_HEIGHT / 4

  MID_LINE_Y = UP_LINE_Y + ROAD_H

  LOW_LINE_Y = Setting::UP_LINE_Y + 2*Setting::CAR_FULL_W


  #one way lane size and coordinates
  LANE_W =(Road::RANGE_ONE_WAY[1] - Road::RANGE_ONE_WAY[0]) * CAR_FULL_W

  #upline of 1 way lane
  LANE_UPLINE_X1 = UP_LINE_X + ROAD_W
  LANE_UPLINE_X2 = LANE_UPLINE_X1 + LANE_W

  #low line of one way lane
  LANE_UPLINE_Y = UP_LINE_Y + CAR_PADDING
  LANE_LOW_LINE_Y = LOW_LINE_Y - CAR_PADDING
end
