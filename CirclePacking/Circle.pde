class Circle {
  float x, y, r;
  
  boolean growing = true;
  
  int maxRadius;
  
  Circle(float x_, float y_) {
    x = x_;
    y = y_;
    r = 1;

    maxRadius = floor(random(10, 100));
  }
  
  void grow() {
    if (growing) {
      r = r + 1;
      if (edges() || hitMax()){
        growing = false;
      }
    }
  }
  
  boolean edges() {
    return x + r >= width || x - r <= 0 || y + r >= height || y - r <= 0;
  }
  
  boolean hitMax() {
    return r>= maxRadius;
  }
  
  void show() {
    stroke(255);
    strokeWeight(2);
    noFill();
    ellipse(x, y, r*2, r*2);
  }
}
