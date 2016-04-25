class Person {

  float values[];
  float x;
  float y;
  float radius;
  float currentValue;
  float EASING = 0.1;
  
 


  Person(int numValues) {
    //instantiate array
    values = new float[numValues];
  }

  public void setValue(int index, float value) {
    values[index] = value;
  }

  public void setIndex(int index) {
    
    //ease currentValue to value of index
    currentValue = currentValue + (values[index] - currentValue)*EASING;
    
    //update y position
    y = height - (height * currentValue);
    
    //update radius
    radius = 10 + 60 * currentValue;
  }

  public void draw() {
    color c = color(currentValue, 255, 255, 255*currentValue);
    fill(c);
    ellipse(x, y, radius, radius);
  }
  
}