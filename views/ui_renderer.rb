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
    roads.each do |_,road|
      puts "------------------------------------\n"
      road.cars.each do |car|
        raise "car is nil" unless car.class == Car
        raise "road is nil" unless road.class == Road
        car.print_car_pos
      end
    end
  end

end
