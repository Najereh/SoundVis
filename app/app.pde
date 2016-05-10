import processing.video.*;
import controlP5.*;

/**
 * Processing Sound Library, Example 6
 * 
 * This sketch shows how to use the Amplitude class to analyze a
 * stream of sound. In this case a sample is analyzed. The smoothFactor
 * variable determines how much the signal will be smoothed on a scale
 * from 0 - 1.
 */

import processing.sound.*;

//media
SoundFile sample;
Amplitude rms;

Movie myMovie;

// Declare a scaling factor
float scale = 5.0;

// Declare a smooth factor
float smoothFactor = 0.25;

// Used for smoothing
float sum;

//timer, every second incoming sensor data
int timer;

//image
PImage img;

//classes
Person[] persons;
Average average;
UIView uiView;
Model model;

//static vars
int NUM_PERSONS = 15;
float MAX_VALUE = 1000.0;
int NUM_VALUES = 0;


int millisStart;
int lastMillis = -1;

int currentIndex = 0;

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

  //image
  img = loadImage("schraffur.png");

  setupMedia();
  //create Persons
  setupPersons();
  setupAverage();
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
    println("initialize!!!! : " + model.getMediaVideoSource());


    /*sample = new SoundFile(this, model.getMediaAudioSource());
    sample.cue(6);
    sample.play();
    */
    AudioIn channel = new AudioIn(this, 1);
    
      rms.input(channel);
        myMovie = new Movie(this, model.getMediaVideoSource());
    myMovie.play();
    /*

     uiView = new UIView(this, myMovie);
     */
  }

  // rms.input(sample);
}


void setupPersons() {

  NUM_VALUES = model.getNumRows();
  println(NUM_VALUES + " total rows in table"); 

  //instantiate Person array
  persons = new Person[NUM_PERSONS];
  for (int i = 0; i < NUM_PERSONS; i ++) {
    float[] values = model.getValuesByPerson(i);
    Person person = new Person(i, values);
    persons[i] = person;
  }

  //assign values
  /*int count =0;
   //for (TableRow row : table.rows()) {
   for (int i = 0; i < NUM_PERSONS; i ++) {
   float value = row.getFloat(i + 1) / MAX_VALUE;
   persons[i].setValue(count, value);
   }
   //increase count
   count ++;
   }*/

  //position Persons
  int rowWidth = int(width / (NUM_PERSONS + 1));
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

void draw() {

  // Set background color, noStroke and fill color
  background(255);//0, 0, 0);
  noStroke();

  image(myMovie, 0, 0, width/2, height);


  //fill(0, 0, 150); only needed when ellipse

  //draw sensor data

  //fill(0, 0, 0, 100);
  //rect(0, 0, width/2, height);

  // Smooth the rms data by smoothing factor
  sum += 0.0;//(rms.analyze() - sum) * smoothFactor;  
  //println(rms.analyze());
  // rms.analyze() return a value between 0 and 1. It's
  // scaled to height/2 and then multiplied by a scale factor
  float rmsScaled = sum * (height/2) * scale;

  int currentMillis = millis();
  int elapsedMillis = currentMillis - lastMillis;
  if (elapsedMillis > 1000) {
    int index = frameCount % NUM_VALUES;
    average.setIndex(index);
    updatePersons(index, rmsScaled);
  }
  //reset 
  lastMillis = lastMillis + 1000;


  //average.draw(sum);
  //drawLines();
  //drawPersons();

  //todo comment this out...
  //drawGrid();
}

void updatePersons(int index, float radius) {


  // Draw image at a size based on the audio analysis
  /*image(img, 50, 50, rmsScaled, rmsScaled);
   image(img, 100, 50, rmsScaled, rmsScaled);
   image(img, 100, 100, rmsScaled, rmsScaled);
   
   image(img, 150, 150, rmsScaled, rmsScaled);
   image(img, 200, 150, rmsScaled, rmsScaled);
   image(img, 200, 200, rmsScaled, rmsScaled);
   
   image(img, 400, 250, rmsScaled, rmsScaled);
   image(img, 450, 250, rmsScaled, rmsScaled);
   image(img, 400, 300, rmsScaled, rmsScaled);
   
   image(img, 500, 150, rmsScaled, rmsScaled);
   image(img, 500, 200, rmsScaled, rmsScaled);
   image(img, 550, 150, rmsScaled, rmsScaled);*/

  for (int i = 0; i < NUM_PERSONS; i ++) {
    persons[i].setRadius(radius);
    persons[i].setIndex(index);
    persons[i].draw();
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

void drawPersons() {
  for (int i = 0; i < NUM_PERSONS; i ++) {
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