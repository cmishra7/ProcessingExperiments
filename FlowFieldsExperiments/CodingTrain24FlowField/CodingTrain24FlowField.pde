float inc = 0.1;
int scl = 5;
int cols, rows;

Particle[] particles;
PVector[][] flowfield;

float zoff = 0;

void setup() {
  size(800, 800); 
  cols = ceil(width/scl);
  rows = ceil(height/scl);
  background(255);
  
  particles = new Particle[10000];
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
  }
  
  flowfield = new PVector[cols][rows];
}

void draw() {
  //randomSeed(10);
  float yoff = 0;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      float angle = noise(xoff, yoff, zoff) * TWO_PI * 4;
      //println(angle + " " + xoff + " " + yoff);
      PVector v = PVector.fromAngle(angle);
      v.setMag(1);
      flowfield[x][y] = v;
      xoff += inc;
      /*stroke(0, 50);
      push();
      translate(x* scl, y * scl);
      rotate(v.heading());
      strokeWeight(1);
      line(0, 0, scl, 0);
      pop();*/
    }
    yoff += inc;
    
    zoff += 0.001;
  }
  
  strokeWeight(4);
  for (int i = 0; i < particles.length; i++) {
    particles[i].update();
    particles[i].show();
    follow(particles[i]);
  }
  
}

void follow(Particle p) {
  p.edges();
  int x = floor(p.pos.x / scl);
  int y = floor(p.pos.y / scl);
  //println(p.pos.x+ " " +p.pos.y);
  PVector force = flowfield[x][y];
  p.applyForce(force);
}
