class Person {

  float values[];
  float x;
  float y;
  float radius;
  float currentValue;
  float targetValue;
  float EASING = 0.1;
  int id;
  float min;
  float max;

  Person(int id, float[] values) {
    //instantiate array
    this.id = id;
    this.values = values;
    
    //see how you're declaring the variables here?
    //this means these variables exist in the scope of this 
    //method only, and are different variables from the variables declared 
    //at the start of the class. This means min and max (from above) never
    //get values assigned
    float min = min(values);
    float max = max(values);
    
    this.min = min;
    this.max = max;
   
    
  }

  public void setValue(int index, float value) {
    values[index] = value;
  }

  public void setScale(float scale) {
  }  

  public void setRadius(float r) {
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
    color c = model.getColorByIndex(id);
    fill(c, 100);
    noStroke();
    ellipse(x, y, radius, radius);
    //image(img, x, y, radius, radius);
  }
  
  public void drawMapped() {
    //ease currentValue to value of index
    currentValue = currentValue + (targetValue - currentValue)*EASING;
    
    //update y position with mapping
    y = height - (height * currentValue);
    float m = map(y, min, max, 0, height);
    //println(id, min, max);
    //println("mapped value" + id +m);

    //update radius
    //radius = 10 + 60 * currentValue;
    color c = model.getColorByIndex(id);
    fill(c, 100);
    noStroke();
    ellipse(x, m, radius, radius);
    
    //image(img, x, y, radius, radius);
  }
  
  
}