class Average {

  float values_a[];
  float x;
  float y;
  float radius;
  float currentValue;
  float targetValue;
  float EASING = 0.1;

  Average(float[] values) {
    //instantiate array
    values_a = values;
  }

  public void setIndex(int index) {
    
    //ease currentValue to value of index
    //currentValue is a number between 0 and 1
    targetValue = values_a[index];

  }

  public void draw() {
    
    currentValue = currentValue + (targetValue - currentValue)*EASING;
        
    //update y position
    y = height - (height * currentValue);
    
    //update radius
    //radius = 10 + 60 * currentValue;
    
    //color c = color(currentValue, currentValue, 255, 255*currentValue);
    //fill(c);
    //rect(x, y, radius, radius);
    
    //stroke(255);
   // line(0, y, width, y);
  }
  
}