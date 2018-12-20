require "gtk2"
require "glib"
require_relative "setting.rb"
require_relative "draw_road_util.rb"
require_relative "draw_car_util.rb"

class UiRenderer
  UPDATE_UI_RATE = 0.7

  def self.main!(roads)
    window = Gtk::Window.new
    window.signal_connect("destroy") { Gtk.main_quit }
    window.set_size_request(
      Setting::WINDOW_WIDTH,
      Setting::WINDOW_HEIGHT)

    area = Gtk::DrawingArea.new
    area.signal_connect('expose_event'){expose_handler(area, roads)}
    GLib::Timeout.add_seconds(UPDATE_UI_RATE){area.queue_draw()}

    window.add(area);
    window.show_all
    Gtk.main
  end

  private
  def self.draw_cars(area,cars)
    cars.each{|car| DrawCarUtil.draw_car!(area,car)}
  end

  def self.draw_roads(area,roads)
    line_width = 3

    gc = Gdk::GC.new(area.window)
    #set GC attributes
    gc.set_rgb_fg_color Gdk::Color.parse("DarkSlateGray")
    gc.set_line_attributes(line_width, Gdk::GC::LINE_SOLID, Gdk::GC::CAP_BUTT,Gdk::GC::JOIN_MITER)

    #draw road
    DrawRoadUtil.draw_upper_line!(gc,area)
    DrawRoadUtil.draw_mid_line!(gc,area)
    DrawRoadUtil.draw_lower_line!(gc,area)
  end

  def self.expose_handler(area, roads)
    draw_roads(area,roads)
    roads.each do |_,road|
      draw_cars(area,road.cars)
    end
  end
end
