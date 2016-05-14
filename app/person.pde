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
    radius = 30;
    color c = (255);
    fill(c);
    noStroke();
    //ellipse(x, y, radius, radius);
    //image(img, x, y, radius, radius);
  }
  
  public void drawMapped() {
    //ease currentValue to value of index
    currentValue = currentValue + (targetValue - currentValue)*EASING;
    
    //update y position with mapping
    y = height - (height * currentValue);
    println("y: " + y);
    float m = (map(y, min, max, 100, height-100))/MAX_VALUE;
    println("id: " + id, "min value: " + min, "max value: " + max); 
    println("height: " + height + " mapped value: " + m);
   
    //update radius
    //radius = 10;
    
    color c = model.getColorByIndex(id);
    fill(c, 80);
    noStroke();
    ellipse(x, m, radius, radius);
  }
  
  
}