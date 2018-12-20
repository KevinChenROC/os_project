module DrawRoadUtil

  #Gtk::Window size
  WINDOW_WIDTH = 1000
  WINDOW_HEIGHT = 1000

  #CAR image attributes
  CAR_W = WINDOW_WIDTH / (Road::FULL_LENGTH * 2);
  CAR_H = CAR_W
  CAR_PADDING = CAR_W / 3
  CAR_FULL_W = (CAR_W + CAR_PADDING)

  #Road src x and y, and size
  SRC_X = CAR_W
  SRC_Y = WINDOW_HEIGHT / 4
  ROAD_W = Road::RANGE_ONE_WAY[0] * CAR_FULL_W
  ROAD_H = CAR_H

  #one way lane size
  LANE_W =(Road::RANGE_ONE_WAY[1] - Road::RANGE_ONE_WAY[0]) * CAR_FULL_W

  def self.upper_line_points()
    lane_x1 = SRC_X + ROAD_W
    lane_y1 = SRC_Y + CAR_PADDING
    lane_x2 = lane_x1 + LANE_W

    points =  [
      [SRC_X, SRC_Y],
      [lane_x1, SRC_Y],
      [lane_x1, lane_y1],
      [lane_x2, lane_y1],
      [lane_x2, SRC_Y],
      [lane_x2 + ROAD_W,SRC_Y]
    ]
  end

  def self.mid_line_points()
  end


end
