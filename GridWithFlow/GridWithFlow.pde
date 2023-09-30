int scl = 400;
int margin = 200;
int step = 2;
int x_scl = 240;
int thickness = 40;

int HEIGHT;
int WIDTH;

int particle_scl = 25;
int cols, rows;

Particle[] particles;
PVector[][] flowfield;

float zoff = 0;

PVector[][] horz_lines;
PVector[][] vert_lines;



ColorPalette PAL_A;


void setup() {
  size(1200, 800);
  background(255);
  
  HEIGHT = height * 4;
  WIDTH = width * 4;
  //HEIGHT = height;
  //WIDTH = width;
  
  int num = ceil(HEIGHT/scl);
  horz_lines = new PVector[num][2];
  num = ceil(WIDTH/x_scl);
  vert_lines = new PVector[num][2];
  generatePalettes();

  cols = ceil(WIDTH/particle_scl);
  rows = ceil(HEIGHT/particle_scl);
  
  particles = new Particle[10];
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
  }
  
  flowfield = new PVector[cols][rows];
  println(cols + " " + rows);
}

void generatePalettes() {
  color[] palette = new color[5];
  /*
  // fraserburgh
  palette[0] = #c64830;
  palette[1] = #fbd67d;
  palette[2] = #598b42;
  palette[3] = #aca68c;
  palette[4] = #a0acb8; */
  
  //auchenblae
  
  palette[0] = #dddbb4;
  palette[1] = #94b6b7;
  palette[2] = #6f8c6e;
  palette[3] = #365f63;
  palette[4] = #131419;
  
  PAL_A = new ColorPalette(palette);
}

void draw() {
  //noLoop();
  scale(0.25);
  if (frameCount == 1)
    drawTheGrid();
  
  
  // Now animate the particles
  danceWithParticles(); 
}

void drawTheGrid() {
  float yoff = 0;
  float inc = 5;
  
  int curr = 0;
  
  strokeWeight(6);
  for (int y = 0; y < HEIGHT; y+= scl) {
    float y_left = y + map(noise(1, yoff), 0, 1, scl -  3*margin, scl - margin);
    float y_right = y + map(noise(WIDTH, yoff), 0, 1, margin, 3 * margin);
    //line(0, y_left, WIDTH, y_right);
    println(y + " " + y_left + " " + y_right);    
    yoff += inc;
    horz_lines[curr][0] = new PVector(0, y_left);
    horz_lines[curr][1] = new PVector(WIDTH, y_right);
    curr++;
  }
  
  float xoff = 0;
  inc = 0.01;
  // Now draw each line
  for (int i = 0; i < horz_lines.length; i++) {
    color pal = PAL_A.getRandomColor();
    float y_delta = horz_lines[i][1].y - horz_lines[i][0].y;

    for (float x = 0; x < WIDTH; x += step) {
      xoff += inc;
      float y = horz_lines[i][0].y + y_delta * x / WIDTH;
      //println(y);
      float alpha = map(noise(xoff, 1000), 0, 1, 90, 100);
      if (alpha < 94)
        continue;
      stroke(pal, alpha);
      strokeWeight(step);
      float top_y = y + map(noise(xoff, yoff, 0), 0, 1, 0, thickness);
      float bottom_y = y - map(noise(xoff, yoff, 100), 0, 1, 0, thickness);
      line(x, top_y, x, bottom_y);
    }
  }
  
  // Now for vert lines
  
  xoff = 0;
  inc = 0.2;

  stroke(0, 10);
  curr = 0;
  for (int x = 0; x < WIDTH; x+= x_scl) {
    float x_top = x + map(noise(xoff, 1), 0, 1, 0, x_scl/2);
    float x_bottom = x + map(noise(xoff, HEIGHT), 0, 1, x_scl/2, x_scl);
    line(x_top, 0, x_bottom, HEIGHT);
    xoff += inc;
    vert_lines[curr][0] = new PVector(x_top, 0);
    vert_lines[curr][1] = new PVector(x_bottom, HEIGHT);
    curr++;
  }
  
  xoff = 0;
  inc = 0.002;
  // Now draw each line
  for (int i = 0; i < vert_lines.length; i++) {
    color pal = PAL_A.getRandomColor();
    float x_delta = vert_lines[i][1].x - vert_lines[i][0].x;
    for (float y = 0; y < HEIGHT; y += step) {
      xoff += inc;
      
      float alpha = map(noise(xoff + 10000, 1000), 0, 1, 80, 100);
      if (alpha < 85)
        continue;
      float x = vert_lines[i][0].x + x_delta * y / HEIGHT;
      stroke(pal, alpha);
      strokeWeight(step);
      float left_x = x + map(noise(xoff, yoff, 0), 0, 1, 0, thickness);
      float right_x = x - map(noise(xoff, yoff, 100), 0, 1, 0, thickness);
      line(left_x, y, right_x, y);
    }
  }
}

void danceWithParticles() {
  
  //println("in DWP "+ frameCount);
  float inc = 0.1;
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
  int x = floor(p.pos.x / particle_scl);
  int y = floor(p.pos.y / particle_scl);
  //println(p.pos.x+ " " +p.pos.y);
  PVector force = flowfield[x][y];
  p.applyForce(force);
}

boolean isPixelOccupied(int x, int y) {
  loadPixels();
  int addr = x + y * width;
  color col = pixels[addr];
  if (red(col) == 255 && green(col) == 255 && blue(col) == 255)
    return false;
  return true;
}

class ColorPalette {
  color[] colors;
  
  ColorPalette(color[] colors) {
    this.colors = colors;
  }
  
  color getRandomColor() {
    return colors[(int) random(colors.length)];
  }
}


class Particle {
  PVector pos, vel, acc, prev;
  float maxSpeed = 100;
  
  Particle() {
    pos = new PVector(random(WIDTH), random(HEIGHT));
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
    //println("drawing something "+frameCount);
    stroke(0, 90);
    strokeWeight(1);
    edges();
    line (pos.x, pos.y, prev.x, prev.y);
    //point(pos.x, pos.y);
    updatePrev();
  }
  
  void edges() {
    
    if (pos.x >= WIDTH) {
      pos.x = 1;
      updatePrev();
    }
    if (pos.x <= 0) {
      pos.x = WIDTH - 1;
      updatePrev();  
    }
    if (pos.y >= HEIGHT) {
      pos.y = 1;
      updatePrev();
    }
    if (pos.y <= 0) {
      pos.y = HEIGHT - 1;
      updatePrev();
    }
    
    if (isPixelOccupied(floor(pos.x/4), floor(pos.y/4))) {
      pos.x = random(WIDTH);
      pos.y = random(HEIGHT);
      updatePrev();
    }

  }
  
}
