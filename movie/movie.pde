import processing.video.*;
Movie myMovie;

void setup() {
   fullScreen();
  
  myMovie = new Movie(this, "jazzvideo_short.mov");
  myMovie.play();
  // no sound
  myMovie.volume(0);
}

void draw() {
  background(0); 
  image(myMovie, 0, 200, width/2, height/2);
  stroke(255);
  line(width/2, 0, width/2, height);
  
}

void movieEvent(Movie m) {
  m.read();
  float mt = myMovie.time();
  float md = myMovie.duration();
}