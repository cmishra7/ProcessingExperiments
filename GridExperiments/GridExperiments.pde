int scl = 400;
int margin = 200;
int step = 2;
int x_scl = 240;
int thickness = 40;

int HEIGHT;
int WIDTH;


PVector[][] horz_lines;
PVector[][] vert_lines;



ColorPalette PAL_A;


void setup() {
  size(1200, 800);
  background(#ebeae6);
  
  HEIGHT = height * 4;
  WIDTH = width * 4;
  
  int num = ceil(HEIGHT/scl);
  horz_lines = new PVector[num][2];
  num = ceil(WIDTH/x_scl);
  vert_lines = new PVector[num][2];
  generatePalettes();
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
  noLoop();
  scale(0.25);
  /*// Draw yourself a grid first.
  for (int y = 0; y <= HEIGHT; y+= scl) {
    line(0, y, WIDTH, y);
  }*/
  
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

class ColorPalette {
  color[] colors;
  
  ColorPalette(color[] colors) {
    this.colors = colors;
  }
  
  color getRandomColor() {
    return colors[(int) random(colors.length)];
  }
}
