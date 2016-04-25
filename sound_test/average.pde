class average {

  float values_a[];
  float x;
  float y;
  float radius;
  float currentValue;
  float EASING = 0.1;

  average(int numValues) {
    //instantiate array
    values_a = new float[numValues];
  }

  public void setValue(int index, float value) {
    values_a[index] = value;
  }

  public void setIndex(int index) {
    
    //ease currentValue to value of index
    currentValue = currentValue + (values_a[index] - currentValue)*EASING;
    
    //update y position
    y = height - (height * currentValue);
    
    //update radius
    radius = 10 + 60 * currentValue;
  }

  public void draw() {
    color c = color(currentValue, currentValue, 255, 255*currentValue);
    fill(c);
    rect(x, y, radius, radius);
  }
  
}