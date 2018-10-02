

def simulation
  init_variables
  poission_process = Thread.new do
    for_a_period_of_time_do_the_following do
      t = Thread.new do
        car = Car.new
        #put car into east or west_road

        while(true) do
          sleep(0.5)
          car.move!
          break if car.at_end?
        end
      end
      t.start
    end
  end
  poission_process.start #daemon for simulation
  render_gui
end
