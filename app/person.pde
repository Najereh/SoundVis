class Person {

  float values[];
  float x;
  float y;
  float mY;
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
    
    float min = min(values);
    float max = max(values);
    
    this.min = min;
    this.max = max;
    
    this.y=values[2];
    
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
    targetValue = values[1];
  }

  public void draw() {
    //ease currentValue to value of index
    currentValue = currentValue + (targetValue - currentValue)*EASING;

    //update y position
    //y = height - (height * currentValue);
   y= values[2];
    //update radius
    
    color c = (255);
    fill(c);
    noStroke();
    //ellipse(x, y, radius, radius);
    //image(img, x, y, radius, radius);
    
    drawMapped();
  }
  
  public float getRelativeValue(){
   return map(currentValue, min, max, 0.0, 1.0);
  }
  
  public void drawMapped() {

    //update y position with mapping
    y = height - (height * currentValue);
    mY = (map(currentValue, min, max,height, 0));// height-100, 100));

    //update radius
    //radius = 10 + 60 * currentValue;
    
    color c = model.getColorByIndex(id);
    fill(c, 100);
    noStroke();
    ellipse(x, mY, radius, radius);
  }
  
  
}