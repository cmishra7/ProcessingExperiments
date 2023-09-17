class Particle {
  PVector pos, vel, acc, prev;
  float maxSpeed = 1;
  
  Particle() {
    pos = new PVector(random(width), random(height));
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    prev = pos.copy();
  }
  
  void update() {
    updatePrev();
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
    vel.limit(maxSpeed);
  }
  
  void updatePrev()
  {
    prev.x = pos.x;
    prev.y = pos.y;
  }
  
  void applyForce(PVector force) {
    acc.add(force);
  }
  
  void show() {
    stroke(0, 5);
    strokeWeight(1);
    edges();
    line (pos.x, pos.y, prev.x, prev.y);
    //point(pos.x, pos.y);
    updatePrev();
  }
  
  void edges() {
    if (pos.x >= width) {
      pos.x = 1;
      updatePrev();
    }
    if (pos.x <= 0) {
      pos.x = width - 1;
      updatePrev();  
    }
    if (pos.y >= height) {
      pos.y = 1;
      updatePrev();
    }
    if (pos.y <= 0) {
      pos.y = height - 1;
      updatePrev();
    }
  }  
}
