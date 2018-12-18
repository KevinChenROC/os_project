require "gtk3"

class UiRenderer
  UPDATE_UI_RATE = 0.7

  def self.main!(roads)
    init_gui
  end

  private
  def self.init_gui()

    button = Gtk::Button.new("Hello World")
    button.signal_connect("clicked") {
      puts "Hello World"
    }

    window = Gtk::Window.new

    window.signal_connect("destroy") {
      puts "destroy event occurred"
      Gtk.main_quit
    }

    window.border_width = 10
    window.add(button)
    window.show_all

    Gtk.main
  end

end
