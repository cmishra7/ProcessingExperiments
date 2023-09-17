int cols, rows;
int scl = 20;
int w = 6000;
int h = 8000;

float flying = 0;

float[][] terrain;

void setup() {
  size (1000, 1000, P3D);

  cols = floor(w/scl);
  rows = floor(h / scl);
  
  terrain = new float[cols][rows];
}

void draw() {
  background(0);
  stroke(255, 20);
  fill(23, 56, 89);;
  
  flying -= 0.05;
  
  float yoff = flying;
  float inc = 0.1;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = map(noise(xoff + flying,yoff), 0, 1, -100, 50);
      xoff += inc;
    }
    yoff += inc;
  }
  
  translate(width/2, height/2);
  rotateX(PI/3);
  translate(-w/2, -h/2);
  for (int y = 0; y < rows -1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
        vertex(x*scl, y*scl, terrain[x][y]);
        vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
    }
    endShape();

  }
}
