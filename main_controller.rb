#0. run some simulation using random
#1. Do text ui
#2. do gui with SHOES!
require_relative "car/car_maker"
require_relative "car/car.rb"
require_relative "road/road.rb"
require_relative "views/ui_renderer.rb"

UPDATE_UI_RATE = 0.5

def simulation
  roads = {WEST => Road.new(WEST), EAST => Road.new(EAST)}

  Thread.new{CarMaker.make_car_threads(roads);}.join

  while(true) do
    sleep UPDATE_UI_RATE
    UiRenderer.render_ui(roads)
  end
end

simulation
