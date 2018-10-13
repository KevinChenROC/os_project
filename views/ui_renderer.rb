module UiRenderer
  def self.render_ui(roads)
    puts "------------------------------------\n"
    roads.each do |_,road|
      road.cars.each do |car|
        car.print_car_pos
      end
    end
  end

end
