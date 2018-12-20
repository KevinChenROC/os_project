module DrawRoadUtil

  #Gtk::Window size
  WINDOW_WIDTH = 1000
  WINDOW_HEIGHT = 1000

  #CAR image attributes
  CAR_W = WINDOW_WIDTH / (Road::FULL_LENGTH * 2);
  CAR_PADDING = CAR_W / 3
  CAR_FULL_W = (CAR_W + CAR_PADDING)

  #Road src x and y, and size
  SRC_X = CAR_FULL_W
  SRC_Y = WINDOW_HEIGHT / 4
  ROAD_W = Road::RANGE_ONE_WAY[0] * CAR_FULL_W
  ROAD_H = CAR_FULL_W

  #one way lane size
  LANE_W =(Road::RANGE_ONE_WAY[1] - Road::RANGE_ONE_WAY[0]) * CAR_FULL_W

  def self.draw_upper_line!(gc,area)
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

    area.window.draw_lines(gc, points)
  end

  def self.draw_mid_line!(gc,area)
    y1 = SRC_Y + ROAD_H
    x2 = SRC_X+ROAD_W-CAR_FULL_W
    x3 = SRC_X + CAR_FULL_W +
     (Road::FULL_LENGTH - Road::RANGE_ONE_WAY[0]) * CAR_FULL_W


    points=[
      [SRC_X,y1],
      [x2,y1],
    ]
    area.window.draw_lines(gc, points)

    points = [
      [x3, y1],
      [x3+ROAD_W-CAR_FULL_W, y1]
    ]

    area.window.draw_lines(gc, points)
  end


end
