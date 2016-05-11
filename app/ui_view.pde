class UIView {

  ControlP5 controller;
  boolean visible = true;
  Movie myMovie;
  Slider slider;
  boolean isPaused = false;

  float sliderPosition = 0.0;
  float targetPosition = 0.0;
  boolean sliderDown = false;

  int lastUpdate = -1;

  UIView(PApplet parent, Movie movie) {

    myMovie = movie;

    controller = new ControlP5(parent);
    controller.addToggle("toggle")
      .setSize(20, 20)
      .setLabelVisible(false)
      .setPosition(80, height - 30)
      .setValue(false);

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
      }
    } 
    );

    slider.onDrag(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        float value = slider.getValue();
        println("slider : " + value);
        //  myMovie.jump((value / 100.0) * myMovie.duration());
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


  public void update() {

    if (lastUpdate - millis() > 1000) {
      if (!sliderDown) {
        targetPosition = myMovie.time() / myMovie.duration();
      }
      lastUpdate = millis();
    }
   // println(sliderDown);

    if (!sliderDown) {
      sliderPosition += (targetPosition - sliderPosition)*0.5;
    } else {
      sliderPosition = slider.getValue() / 100.0;
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


  void toggle(boolean paused) {

    println("pause! : " + paused);

    if (!paused) {
      myMovie.play();
    } else {
      myMovie.pause();
    }

    isPaused = paused;
  }

  void updateSLider(float value) {
    println("slider : " + value);
    myMovie.jump((value / 100.0) * myMovie.duration());
  }
}