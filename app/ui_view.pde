
class UIView {

  ControlP5 controller;
  boolean visible = false;
  Movie myMovie;

  boolean isPaused = false;

  UIView(PApplet parent, Movie movie) {

    myMovie = movie;

    controller = new ControlP5(parent);
    controller.addToggle("pause").setSize(50, 50);
    controller.setVisible(false);
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

    if (isPaused) {
      myMovie.play();
    } else {
      myMovie.pause();
    }

    isPaused = !isPaused;
  }
}