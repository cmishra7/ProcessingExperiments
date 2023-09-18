ArrayList<Circle> circles;

void setup() {
  size (640, 360);
  background(0);
  circles = new ArrayList<Circle>();
  /*for (int i = 0; i< 50; i++) {
    circles.add(new Circle(random(width), random(height)));
  }*/
}

void draw() {
  //noFill();
  Circle c = newCircle();
  if (c != null) {
    while (c.growing == true) {
      //c.show();
      c.grow();
      if(checkCollision(c)) {
        c.growing = false;
      }
    }
    c.show();
    circles.add(c);
  }
}

boolean checkCollision(Circle n) {
  for (Circle c: circles) {
    float d = dist(n.x, n.y, c.x, c.y);
    if (d - 4 <= c.r + n.r) {
      return true;
    }
  }
  return false;
}

Circle newCircle() {
  float x = random(width);
  float y = random(height);
  boolean valid = true;
  
  for (Circle c: circles) {
    if (dist(x, y, c.x, c.y) < c.r) {
      valid = false;
      break;
    }
  }
  if (valid) {
    return new Circle(x, y);
  } else {
    return null;
  }
  
}
