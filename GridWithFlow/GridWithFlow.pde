int y_scl = 160;
int margin = 50;
int step = 2;
int x_scl = 160;
int thickness = 40;

int HEIGHT;
int WIDTH;

int particle_scl = 25;
int particle_cols, particle_rows;

Particle[] particles;
PVector[][] flowfield;

GridCell[][] gridfield;
int grid_scl = 1;
int grid_cols, grid_rows;

float zoff = 0;

PVector[][] horz_lines;
PVector[][] vert_lines;

// When you change one change the other.
int FACTOR = 4;
float INV_FACTOR = 1/(float)FACTOR;

int NUM_PARTICLES = 2000;



ColorPalette PAL_A;
ColorPalette PAL_B;


void setup() {
  size(1200, 800);
  background(0);
  
  HEIGHT = height * FACTOR;
  WIDTH = width * FACTOR;
  //HEIGHT = height;
  //WIDTH = width;
  
  int num = ceil(HEIGHT/y_scl);
  horz_lines = new PVector[num][2];
  num = ceil(WIDTH/x_scl);
  vert_lines = new PVector[num][2];
  generatePalettes();

  particle_cols = ceil(WIDTH/particle_scl);
  particle_rows = ceil(HEIGHT/particle_scl);
  
  particles = new Particle[NUM_PARTICLES];
  
  flowfield = new PVector[particle_cols][particle_rows];
  println(particle_cols + " " + particle_rows);
  
  setupCollisionCells();
}

void setupCollisionCells() {
  int x = 0;
  int y = 0;
  
  grid_cols = ceil(WIDTH/grid_scl);
  grid_rows = ceil(HEIGHT/grid_scl);
  gridfield = new GridCell[grid_cols][grid_rows];
  for (int j = 0; j < grid_rows; j++) {
    for (int i = 0; i < grid_cols; i++) {
      gridfield[i][j] = new GridCell(x, y, grid_scl, grid_scl);
      x += grid_scl;
    }
    y += grid_scl;
    x = 0;
  }
}

void generatePalettes() {
  //color[] palette = new color[5];
  
  // fraserburgh
  /*palette[0] = #c64830;
  palette[1] = #fbd67d;
  palette[2] = #598b42;
  palette[3] = #aca68c;
  palette[4] = #a0acb8; */
  
  //auchenblae
  
  /*palette[0] = #dddbb4;
  palette[1] = #94b6b7;
  palette[2] = #6f8c6e;
  palette[3] = #365f63;
  palette[4] = #131419;*/
  
  color[] palette = new color[3];
  palette[0] = #c64830;
  palette[1] = #fbd67d;
  palette[2] = #598b42;
  
  PAL_A = new ColorPalette(palette);
  
  color[] palette2 = new color[1];
  //palette2[0] = #aca68c;
  //palette2[1] = #a0acb8;
  palette2[0] = #00E6C6;
  
  PAL_B = new ColorPalette(palette2);
}

void draw() {
  //noLoop();
  scale(INV_FACTOR);
  if (frameCount == 1) {
    drawPaintedGrid();
    checkOccupiedCells();
    // Now initialize particles
    for (int i = 0; i < particles.length; i++) {
      particles[i] = new Particle();
    }
  }
  
  // Now animate the particles
  danceWithParticles(); 
  if (frameCount % 10 == 0) {
    println(frameCount);
  }
}

void drawPaintedGrid() {
  noStroke();
  float yoff = 0;
  float inc = 5;
  
  int curr = 0;
  
  //strokeWeight(6);
  for (int y = 0; y < HEIGHT; y+= y_scl) {
    float y_left = y + map(noise(1, yoff), 0, 1, y_scl -  3*margin, y_scl - margin);
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
      //stroke(pal, alpha);
      stroke(pal);
      strokeWeight(step);
      float top_y = y + map(noise(xoff, yoff, 0), 0, 1, 0, thickness);
      float bottom_y = y - map(noise(xoff, yoff, 100), 0, 1, 0, thickness);
      line(x, top_y, x, bottom_y);
    }
  }
  
  // Now for vert lines
  
  xoff = 0;
  inc = 0.2;

  //stroke(0, 10);
  curr = 0;
  for (int x = 0; x < WIDTH; x+= x_scl) {
    float x_top = x + map(noise(xoff, 1), 0, 1, 0, x_scl/2);
    float x_bottom = x + map(noise(xoff, HEIGHT), 0, 1, x_scl/2, x_scl);
    //line(x_top, 0, x_bottom, HEIGHT);
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
      float alpha = map(noise(xoff + 10000, 1000), 0, 1, 90, 100);
      if (alpha < 94)
        continue;
      float x = vert_lines[i][0].x + x_delta * y / HEIGHT;
      //stroke(pal, alpha);
      stroke(pal);
      strokeWeight(step);
      float left_x = x + map(noise(xoff, yoff, 0), 0, 1, 0, thickness);
      float right_x = x - map(noise(xoff, yoff, 100), 0, 1, 0, thickness);
      line(left_x, y, right_x, y);
    }
  }
}

void checkOccupiedCells() {
  loadPixels();
  for (int j = 0; j < grid_rows; j++) {
    for (int i = 0; i < grid_cols; i++) {
      GridCell c = gridfield[i][j];
      if(isRectOccupied(c.x, c.y, c.w, c.h)) {
        c.occupied = true;
      }
    }
  }
  
  /*
  fill(64, 224, 208, 20);
  for (int j = 0; j < grid_rows; j++) {
    for (int i = 0; i < grid_cols; i++) {
      GridCell c = gridfield[i][j];
      if(c.occupied) {
        rect(c.x, c.y, c.w, c.h);
      }
    }
  }
  */
}

GridCell getGridCellForCoordinate(int x, int y) {
  return gridfield[floor(x/grid_scl)][floor(y/grid_scl)];
}

void danceWithParticles() {
  
  //println("in DWP "+ frameCount);
  float inc = 0.1;
  float yoff = 0;
  for (int y = 0; y < particle_rows; y++) {
    float xoff = 0;
    for (int x = 0; x < particle_cols; x++) {
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
  //loadPixels();
  // assumes pixels are loaded.
  int x_t = floor(x/FACTOR);
  int y_t = floor(y/FACTOR);
  if (x_t >= width || y_t >= height) {
    println("explode " + x_t + " " +y_t);
  }
  int addr = x_t + y_t * width;
  if (addr >= pixels.length) {
    println("explode2 " + x_t + " " +y_t);
  }
  color col = pixels[addr];
  //println(hex(col));
  if (red(col) == 0 && green(col) == 0 && blue(col) == 0)
    return false;
  return true;
}

boolean isRectOccupied(int x, int y, int w, int h) {
  //return false;
  for (int r = y; r < y + h; r++) {
    for (int c = x; c < x + w; c++) {
      if (isPixelOccupied(x, y)) 
        return true;
    }
  }
  return false;
}


class ColorPalette {
  color[] colors;
  
  ColorPalette(color[] colors) {
    this.colors = colors;
  }
  
  color getRandomColor() {
    return colors[(int) random(colors.length)];
    //return colors[colors.length - 1];

  }
}


class Particle {
  PVector pos, vel, acc, prev;
  float maxSpeed = 2;
  color c;
  
  Particle() {
    while (true) {
      pos = new PVector(random(WIDTH), random(HEIGHT));
      GridCell c = getGridCellForCoordinate(floor(pos.x), floor(pos.y));
      if (!c.occupied) {
        break;
      }
    }
    
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    prev = pos.copy();
    c = PAL_B.getRandomColor();
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
    //stroke(c, 5);
    stroke(c);
    strokeWeight(1);
    edges();
    line (pos.x, pos.y, prev.x, prev.y);
    //point(pos.x, pos.y);
    updatePrev();
  }
  
  void edges() {
    boolean hitBoundary = false;
    if (pos.x >= WIDTH) {
      pos.x = prev.x;
      vel.x = -0.1 * vel.x;
      //updatePrev();
      hitBoundary = true;
    }
    if (pos.x <= 0) {
      pos.x = prev.x;
      vel.x = -0.1 * vel.x;
      //updatePrev();
      hitBoundary = true;

    }
    if (pos.y >= HEIGHT) {
      pos.y = prev.y;
      vel.y = -0.1 * vel.y;
      //updatePrev();
      hitBoundary = true;

    }
    if (pos.y <= 0) {
      pos.y = prev.y;
      vel.y = -0.1 * vel.y;
      //updatePrev();
      hitBoundary = true;

    }
    
    if (!hitBoundary) {
      // Check grid collision
      GridCell c = getGridCellForCoordinate(floor(pos.x), floor(pos.y));
      if (c.occupied) {
        pos.x = prev.x;
        pos.y = prev.y;
        vel.x = -0.1 * vel.x;
        vel.y = -0.1 * vel.y;
      }
    }
    
    if (isPixelOccupied(floor(pos.x), floor(pos.y))) {
      //println("hit pixel occupied");
      //println(pos.x + " " + pos.y + " " + vel.x + " " + vel.y);
      //pos.x = random(WIDTH);
      //pos.y = random(HEIGHT);
      vel.x = -1 * vel.x;
      vel.y = -1 * vel.y;

      updatePrev();
    }

  } 
}

class GridCell {
  int x, y, w, h;
  Boolean occupied;
  
  GridCell(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    occupied = false;
  }
}
