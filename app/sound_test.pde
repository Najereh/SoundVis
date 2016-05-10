/**
 * Processing Sound Library, Example 6
 * 
 * This sketch shows how to use the Amplitude class to analyze a
 * stream of sound. In this case a sample is analyzed. The smoothFactor
 * variable determines how much the signal will be smoothed on a scale
 * from 0 - 1.
 */

import processing.sound.*;

// Declare the processing sound variables 
SoundFile sample;
Amplitude rms;

// Declare a scaling factor
float scale = 5.0;

// Declare a smooth factor
float smoothFactor = 0.25;

// Used for smoothing
float sum;

//timer, every second incoming sensor data
int timer;

//Data from sensors
Table table;

//image
PImage img;

//classes
Person[] persons;
Average average;

//static vars
int NUM_PERSONS = 15;
float MAX_VALUE = 1000.0;
int NUM_VALUES = 0;

void setup() {

  //setup rendering..
  //size(640, 360);
  smooth();
  fullScreen();

  //Load and play a soundfile and loop it
  sample = new SoundFile(this, "jazz.mp3");
  sample.loop();

  // Create and patch the rms tracker
  rms = new Amplitude(this);
  rms.input(sample);

  //image
  img = loadImage("schraffur.png");

  //SENSORDATA
  table = loadTable("out_2.csv", "header");

  //create Persons
  setupPersons();
  setupAverage();
}      


void setupPersons() {

  NUM_VALUES = table.getRowCount();
  println(NUM_VALUES + " total rows in table"); 

  //instantiate Person array
  persons = new Person[NUM_PERSONS];
  for (int i = 0; i < NUM_PERSONS; i ++) {
    Person person = new Person(NUM_VALUES);
    persons[i] = person;
  }

  //assign values
  int count =0;
  for (TableRow row : table.rows()) {
    for (int i = 0; i < NUM_PERSONS; i ++) {
      float value = row.getFloat(i + 1) / MAX_VALUE;
      persons[i].setValue(count, value);
    }
    //increase count
    count ++;
  }

  //position Persons
  int rowWidth = int(width / (NUM_PERSONS + 1));
  for (int i = 0; i < NUM_PERSONS; i ++) {
    int x = (i + 1) * rowWidth;
    //println(i + " : " + x);
    persons[i].x = x;
  }
}


void setupAverage() {

  //NUM_VALUES = table.getRowCount();
  //println(NUM_VALUES + " total rows in table"); 

  //instantiate average array
  //average = new average[0];
  float a[] = new float[NUM_VALUES];

  //assign values
  int count =0;
  float averageCount = 0;
  for (TableRow row : table.rows()) {
    for (int i = 0; i < NUM_PERSONS; i ++) {
      float value = row.getFloat(i + 1) / MAX_VALUE;
      averageCount = averageCount+value;
    }

    averageCount = averageCount/NUM_PERSONS;
    a[count] = averageCount;

    println(averageCount);


    //increase count
    count ++;
  }

  average = new Average(a);
}

void draw() {

  // Set background color, noStroke and fill color
  background(0, 0, 0);
  noStroke();

  //fill(0, 0, 150); only needed when ellipse

  //draw sensor data

  fill(0, 0, 0, 100);
  rect(0, 0, width, height);

  // Smooth the rms data by smoothing factor
  sum += (rms.analyze() - sum) * smoothFactor;  

  // rms.analyze() return a value between 0 and 1. It's
  // scaled to height/2 and then multiplied by a scale factor
  float rmsScaled = sum * (height/2) * scale;


  int index = frameCount % NUM_VALUES;

  average.setIndex(index);
  average.draw(sum);

  updatePersons(index, rmsScaled);

  drawLines();

  drawPersons();

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
    Person p = persons[i];
    //stroke(255,0,0);
    //line(p.x, p.y, p.x, average.y);
    
    persons[i].draw();
  }
}
void drawGrid() {

  //just to illustrate the spacing of elements...
  int rowWidth = int(width / (NUM_PERSONS + 1));
  for (int i = 0; i < NUM_PERSONS; i ++) {
    int x = (i + 1) * rowWidth;  
    stroke(125, 0, 0);
    line(x, 0, x, height);
  }
}