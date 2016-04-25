class Person {

  float values[];
  float x;
  float y;
  float radius;
  float currentValue;
  float targetValue;
  float EASING = 0.1;
  

  Person(int numValues) {
    //instantiate array
    values = new float[numValues];
  }

  public void setValue(int index, float value) {
    values[index] = value;
  }
  
  public void setScale(float scale){
  }  
  
  public void setRadius(float r){
     radius = r; 
  }

  public void setIndex(int index) {
    targetValue = values[index];
  }

  public void draw() {
        //ease currentValue to value of index
    currentValue = currentValue + (targetValue - currentValue)*EASING;
    
    //update y position
    y = height - (height * currentValue);
    
    //update radius
    //radius = 10 + 60 * currentValue;
    color c = color(currentValue, 255, 255, 255*currentValue);
    fill(c);
    noStroke();
    ellipse(x, y, radius, radius);
    
    //image(img, x, y, radius, radius);
  }
  
}