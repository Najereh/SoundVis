class Controller {

  ControlP5 controller;

  Movie myMovie;
  Slider slider;
  Toggle toggle;

  boolean isPaused = false;
  boolean visible = true;
  boolean sliderDown = false;
  boolean keyDown = false;

  float sliderPosition = 0.0;
  float targetPosition = 0.0;

  int lastUpdate = -1;

  Controller(PApplet parent, Movie movie) {

    myMovie = movie;

    controller = new ControlP5(parent);
    toggle = controller.addToggle("toggle")
      .setSize(20, 20)
      .setLabelVisible(false)
      .setPosition(80, height - 30)
      .setValue(false);

    toggle.onChange(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        boolean paused = toggle.getBooleanValue();
        if (!paused) {
          myMovie.play();
        } else {
          myMovie.pause();
        }
        isPaused = paused;
      }
    }
    );

    // add a vertical slider
    slider = controller.addSlider("slider")
      .setPosition(110, height - 20)
      .setSize((width/2) - 220, 3)
      .setRange(0, 100)
      .setLabelVisible(false)
      .setValue(128);

    slider.onPress(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        sliderDown = true;
        setValue(slider.getValue());
      }
    } 
    );

    slider.onDrag(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        setValue(slider.getValue());
      }
    } 
    );

    slider.onRelease(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        sliderDown = false;
      }
    }
    );
  }

  public void setValue(float value) {
    targetPosition = (value / 100.0);
    myMovie.jump(targetPosition * myMovie.duration());
  }


  public void update() {

    // println(sliderDown);

    if (millis() - lastUpdate  > 1000) {
      if (!sliderDown) {
        targetPosition = myMovie.time() / myMovie.duration();
        //println(targetPosition, myMovie.time(), myMovie.duration());
      }
      lastUpdate = millis();
    }

    sliderPosition += (targetPosition - sliderPosition)*0.5;

    if (!sliderDown) {
      slider.setValue(sliderPosition * 100.0);
    } else {
      sliderPosition = slider.getValue() / 100.0;
    }

    if (keyPressed) {
      if (!keyDown) {
        keyDown = true;
        toggleShow();
      }
    } else {
      if (keyDown) {
        keyDown = false;
      }
    }
  }

  void show() {
    this.visible = true;
    controller.show();
  }

  void hide() {
    this.visible = false;
    controller.hide();
  }

  void toggleShow() {
    if (this.visible) {
      hide();
    } else {
      show();
    }
  }
}