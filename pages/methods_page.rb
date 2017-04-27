class Methods < BaseClass

  def tap_on_location(x_loc, y_loc, num_of_fingers=1)
    Appium::TouchAction.new.tap(x: x_loc, y: y_loc, fingers: num_of_fingers).release.perform
  end

  def swipe_on_screen(start_x, start_y, end_x, end_y)
    action = Appium::TouchAction.new.press(x: start_x, y: start_y)
                                    .wait(300)
                                    .move_to(x: end_x, y: end_y)
                                    .wait(800)
                                    .release(x: end_x, y: end_y)
    action.perform
  end

end
