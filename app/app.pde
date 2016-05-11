import processing.video.*;
import controlP5.*;
import processing.sound.*;

//media
SoundFile sample;
Amplitude rms;
float rmsScaled;

Movie myMovie;

// Declare a scaling factor
float scale = 2;
// Declare a smooth factor
float smoothFactor = 0.25;

// Used for smoothing
float sum;

//classes
Person[] persons;
Average average;
Model model;

//static vars
int NUM_PERSONS = 19;
float MAX_VALUE = 1000.0;
int NUM_VALUES = 0;

boolean isPaused = false;

int millisStart;
int lastMillis = -1;
int currentIndex = 0;

Controller controller;

void settings() {

  model = new Model();
  if (model.getIsFullScreen()) {
    fullScreen();
  } else {
    size(1280, 360);
  }
}

void setup() {
  smooth();
  setupMedia();
  //create Persons
  setupPersons();
  setupAverage();

  controller = new Controller(this, myMovie);
}      

void setupMedia() {
  println("\n===SETUP MEDIA===");
  println("Type : " + model.getMediaType());
  // Create and patch the rms tracker

  rms = new Amplitude(this);

  if (model.getMediaType().equals("audio")) {
    //Load and play a soundfile and loop it
    sample = new SoundFile(this, model.getMediaAudioSource());
    sample.loop();
    rms.input(sample);
  } else if (model.getMediaType().equals("video")) {
    AudioIn channel = new AudioIn(this, 0);
    channel.start();

    rms.input(channel);
    myMovie = new Movie(this, model.getMediaVideoSource());
    myMovie.play();
   myMovie.volume(0.0);
  }
}


void setupPersons() {

  NUM_VALUES = model.getNumRows();
  println(NUM_VALUES + " total rows in table"); 

  //instantiate Person array
  persons = new Person[NUM_PERSONS];
  for (int i = 0; i < NUM_PERSONS; i ++) {
    float[] values = model.getValuesByPerson(i);
    color c = model.getColorByIndex(i);
    Person person = new Person(i, values);
    persons[i] = person;
  }

  //position Persons
  int rowWidth = int((width * 0.5) / (NUM_PERSONS + 1));
  for (int i = 0; i < NUM_PERSONS; i ++) {
    int x = (i + 1) * rowWidth;
    //println(i + " : " + x);
    persons[i].x = x;
  }
}

void setupAverage() {
  float[] a = model.getAverageValues();
  average = new Average(a);
}

/**
 * Handle app state here
 */
void update() {

  controller.update();

  int currentIndex = floor(myMovie.time());
  
  if (model.setCurrentIndex(currentIndex)) {
    average.setIndex(currentIndex);
    updatePersons(currentIndex, rmsScaled);
    //println("update timecode : " + model.getCurrentTimecode());
  }
}

/**
 * Handle app rendering here
 */
void draw() {

  update();

  // Set background color, noStroke and fill color
  background(255);//0, 0, 0);
  noStroke();
  image(myMovie, 0, 0, width/2, height);

  // Smooth the rms data by smoothing factor
  sum += (rms.analyze() - sum) * smoothFactor;  
  rmsScaled = sum * (height/2) * scale;

  pushMatrix();
  translate(width / 2, 0);
  fill(0, 0, 0, 100);
  rect(0, 0, width/2, height);
  average.draw(sum);
  drawLines();
  drawLines1();
  drawPersons(rmsScaled);
  popMatrix();
  //todo comment this out...
  //drawGrid();
}

void updatePersons(int index, float radius) {
  for (int i = 0; i < NUM_PERSONS; i ++) {
    persons[i].setIndex(index);
  }
}

void drawLines() {
  stroke(255, 50);
  for (int i = 0; i < NUM_PERSONS - 1; i ++) {
    Person p1 = persons[i];
    Person p2 = persons[i + 1];
    line(p1.x, p1.y, p2.x, p2.y);
  }
}

void drawLines1() {
  stroke(255, 50);
  for (int i = 0; i < NUM_PERSONS; i ++) {
    Person p1 = persons[i];
    line(p1.x, p1.y, p1.x, average.y);
    //line(p1.x, p1.y, p1.x-5, average.y);
    line(p1.x, p1.y, p1.x+10, average.y);
    line(p1.x, p1.y, p1.x-10, average.y);
    //line(p1.x, p1.y, p1.x+15, average.y);
    //line(p1.x, p1.y, p1.x-15, average.y);
    line(p1.x, p1.y, p1.x+20, average.y);
    line(p1.x, p1.y, p1.x-20, average.y);
  
  }
}


void drawPersons(float radius) {
  for (int i = 0; i < NUM_PERSONS; i ++) {
    persons[i].setRadius(radius);
    persons[i].draw();
   
  }
}

void drawGrid() {

  //just to illustrate the spacing of elements...
  int rowWidth = int((width * 0.5) / (NUM_PERSONS + 1));
  for (int i = 0; i < NUM_PERSONS; i ++) {
    int x = (i + 1) * rowWidth;  
    stroke(125, 0, 0);
    line(x, 0, x, height);
  }
}

void movieEvent(Movie m) {
  m.read();
}