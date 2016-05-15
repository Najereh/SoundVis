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

  public void draw(float offset) {
    
    currentValue = currentValue + (targetValue - currentValue)*EASING;
        
    //update y position
    y = height - (height * currentValue);// + offset * 100;
  
    stroke(255/*, 100 * offset + 100*/);
    line(0, y, width, y);
     println("y: " + y);
  }
  
}