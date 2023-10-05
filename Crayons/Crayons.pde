int X_DIM = 4000;
float Y_FACTOR = 2;
int THICKNESS = 2;
int CURVINESS = 20 * THICKNESS;

int res = 5;
int cols, rows;
float[][] field;

int X_TRANSLATE = -1000;
int Y_TRANSLATE = -1000;
//int X_TRANSLATE = 200;
//int Y_TRANSLATE = 200;
void setup() {
  size(800, 800);
  background(255);
  cols = width/res;
  rows = height/res;
  field = new float[cols][rows];
  initializeField();
}

void draw() {
  noLoop();
  noFill();
  translate(X_TRANSLATE, Y_TRANSLATE);
  drawFirstHatches();
  drawSecondHatches();
}

void drawFirstHatches() {
  strokeWeight(2);  
  stroke(#5e746a, 80);
  for (int i = X_DIM; i > 0; i -= THICKNESS) {
    int j = ceil(i * Y_FACTOR);
    int x = i - ceil(random(0, THICKNESS));
    int y = j - ceil(random(0, THICKNESS));
    if(x < 0)
      x = 0;
    if(y < 0)
      y = 0;
    int cpx1 = x + ceil(random(0, CURVINESS));
    int cpy1 = ceil(random(0, CURVINESS));
    int cpx2 = ceil(random(0, CURVINESS));
    int cpy2 = y + ceil(random(0, CURVINESS));
    float z = 0;
    while (z < 1) {
      float p_x = curvePoint(cpx1, x, 0, cpx2, z);
      float p_y = curvePoint(cpy1, 0.0, y, cpy2, z);
      if (shouldDisplayFirst(p_x, p_y)) {
        point(p_x, p_y);
      }
      z += 0.0005;
    }
  }
}

void drawSecondHatches() {
  strokeWeight(2);  
  stroke(#6b8a34,80);
  for (int i = 0; i < X_DIM; i += THICKNESS) {
    int j = ceil((X_DIM - i) * Y_FACTOR);
    int x1 = i - ceil(random(0, THICKNESS));
    int y1 = ceil(random(0, THICKNESS));

    int x2 = X_DIM - ceil(random(0, THICKNESS));
    int y2 = j - ceil(random(0, THICKNESS));
    if(x1 < 0)
      x1 = 0;
    if (y1 < 0) 
      y1 = 0;
    if(x2 < 0)
      x2 = 0;
    if(y2 < 0)
      y2 = 0;
    println("drawing between "+ x1 + " " + y1 + " " + x2 + " " + y2);
    //line(x1, y1, x2, y2);
    int cpx1 = x1 + ceil(random(0, CURVINESS));
    int cpy1 = y1 + ceil(random(0, CURVINESS));
    int cpx2 = x2 + ceil(random(0, CURVINESS));
    int cpy2 = y2 + ceil(random(0, CURVINESS));
    float z = 0;
    while (z < 1) {
      float p_x = curvePoint(cpx1, x1, x2, cpx2, z);
      float p_y = curvePoint(cpy1, y1, y2, cpy2, z);
      if (shouldDisplaySecond(p_x, p_y)) {
        point(p_x, p_y);
      }
      z += 0.0005;
    }
  }
}

void initializeField() {
  float xoff = 0;
  float inc = 0.1;
  for (int i = 0; i < cols; i++) {
    float yoff = 0;
    for (int j = 0; j < rows; j++) {
      field[i][j] = map(noise(xoff, yoff), 0, 1, -1, 1);
      yoff += inc;
    }
    xoff += inc;
  }
}

boolean shouldDisplayFirst(float p_x, float p_y) {
  //return true;
  p_x = p_x + X_TRANSLATE;
  p_y = p_y + Y_TRANSLATE;
  int i = floor(p_x/ res);
  int j = floor(p_y/ res);
    if (i >= cols || i < 0 || j >= rows || j < 0) {
    return false;
  }
  if(field[i][j] < 0) {
    return false;
  }
  return true;
}

boolean shouldDisplaySecond(float p_x, float p_y) {
  //return true;
  p_x = p_x + X_TRANSLATE;
  p_y = p_y + Y_TRANSLATE;
  int i = floor(p_x/ res);
  int j = floor(p_y/ res);
    if (i >= cols || i < 0 || j >= rows || j < 0) {
    return false;
  }
  if(field[i][j] < 0) {
    return true;
  }
  return false;
}
