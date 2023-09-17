int res = 5;
int cols, rows;
float[][] field;
float zoff = 0;


void setup() {
  size(600, 600);
  cols = width/res;
  rows = height / res;
  field = new float[cols][rows];
}

void draw() {
  background(127);
  zoff += 0.01;
  float xoff = 0;
  float inc = 0.1;
  for (int i = 0; i < cols; i++) {
    float yoff = 0;
    for (int j = 0; j < rows; j++) {
      field[i][j] = map(noise(xoff, yoff, zoff), 0, 1, -1, 1);
      yoff += inc;
    }
    xoff += inc;
  }
  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
       /*stroke(field[i][j] * 255);
       strokeWeight(res * 0.4);
       point(i * res, j * res);*/
       fill(field[i][j] * 255 + 127, field[i][j] * 127 + 127, field[i][j] * 63 + 127);
       noStroke();
       rect(i * res, j * res, res, res);
     }
  }
  
  for (int i = 0; i < cols - 1; i++) {
    for (int j = 0; j < rows - 1; j++) {
      float x = i * res;
      float y = j * res;
      PVector a = new PVector ( x + res * 0.5, y);
      PVector b = new PVector ( x + res, y + res * 0.5);
      PVector c = new PVector ( x + res * 0.5, y + res);
      PVector d = new PVector ( x, y + res * 0.5);
      
      int state = getState(ceil(field[i][j]), ceil(field[i+1][j]), ceil(field[i + 1][j + 1]), ceil(field[i][j+1]));
      stroke(255);
      strokeWeight(1);
      switch(state) {
        case 0:
        case 15:
          break;
        case 1:
        case 14:
          line(c,d);
          break;
        case 2:
        case 13:
          line(b,c);
          break;
        case 3:
        case 12:
          line(b,d);
          break;
        case 4:
        case 11:
          line(b,a);
          break;
        case 5:
          line(a,d);
          line(b,c);
          break;
        case 6:
        case 9:
          line(a,c);
          break;
        case 7:
        case 8:
          line(a,d);
          break;
        case 10:
          line(c,d);
          line(a,b);
          break;                
      }
    }
  }
}

void line(PVector a, PVector b) {
  line(a.x, a.y, b.x, b.y);
}

int getState (int a, int b, int c, int d) {
  return a * 8 + b * 4 + c * 2 + d * 1;
}
