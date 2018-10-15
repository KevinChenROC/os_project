module UiRenderer
  UPDATE_UI_RATE = 1

  def self.new_ui_render_daemon!(roads)
    Thread.new do
      while true
        UiRenderer.render_ui roads
        sleep UPDATE_UI_RATE
      end
    end
  end

  private
  def self.render_ui(roads)
    puts "\n\n***************************************\n"
    roads.each do |_,road|
      puts "\n--------------#{road.direction} road--------------------"
      road.cars.each do |car|
        raise "car is nil" unless car.class == Car
        raise "road is nil" unless road.class == Road
        print_car_pos car
      end
    end
    print_one_way_lane
    puts "\n\n***************************************\n"
  end

  def self.print_one_way_lane
    puts "\n\nCapacity= #{OneWayLane.capacity_one_way.available_permits}"
    puts "direction_mutex lock = #{OneWayLane.direction_locked?}"
    puts "Direction One Way  = #{OneWayLane.direction_one_way}"
  end

  def self.print_car_pos(car)
    str = "#{car.direction}_car, @id = #{car.id}, @x_pos = #{car.x_pos}."
    if car.in_one_way_lane?
      str += " In one way lane."
    end
    puts str
  end

end
