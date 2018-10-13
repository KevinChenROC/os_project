#0. run some simulation using random
#1. Do text ui
#2. do gui with SHOES!
require_relative "car/car_maker"
require_relative "car/car.rb"
require_relative "road/road.rb"
require_relative "views/ui_renderer.rb"

DAEMON_RUNNING_LIMI = 1

def simulation
  OneWayLane.init_shared_variables
  roads = {WEST => Road.new(WEST), EAST => Road.new(EAST)}

  CarMaker.new_car_maker_daemon!(roads).join(DAEMON_RUNNING_LIMI)
  UiRenderer.new_ui_render_daemon!(roads).join

  #   # CarMaker.make_an_car_thread!(roads)
  # end
end

simulation
