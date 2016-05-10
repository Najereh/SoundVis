
class UIView {

  ControlP5 controller;
  boolean visible = true;
  Movie myMovie;

  boolean isPaused = false;

  UIView(PApplet parent, Movie movie) {

    myMovie = movie;

    controller = new ControlP5(parent);
    controller.addToggle("toggle").setSize(50, 50).setValue(true);
    // controller.setVisible(false);
  }


  void show() {
    this.visible = true;
    controller.show();
  }

  void hide() {
    this.visible = false;
    controller.hide();
  }

void toggle(boolean theFlag) {
  if(theFlag==true) {
  //  col = color(255);
  } else {
    //col = color(100);
  }
  println("a toggle event.");
}
}