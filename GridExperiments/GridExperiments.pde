int scl = 50;
int margin = 40;
int step = 2;
int x_scl = 45;
int thickness = 10;

PVector[][] horz_lines;
PVector[][] vert_lines;


color[] palette;

void setup() {
  size(450, 800);
  background(255);
  
  int num = ceil(height/scl);
  horz_lines = new PVector[num][2];
  num = ceil(width/x_scl);
  vert_lines = new PVector[num][2];
  
  palette = new color[5];
  palette[0] = #DDDBB4;
  palette[1] = #94B6B7;
  palette[2] = #6f8c6E;
  palette[3] = #365f63;
  palette[4] = #131419;
}

void draw() {
  noLoop();
  /*// Draw yourself a grid first.
  for (int y = 0; y <= height; y+= scl) {
    line(0, y, width, y);
  }*/
  
  float yoff = 0;
  float inc = 5;
  
  int curr = 0;
  
  strokeWeight(6);
  for (int y = 0; y < height; y+= scl) {
    float y_left = y + map(noise(1, yoff), 0, 1, scl -  3*margin, scl - margin);
    float y_right = y + map(noise(width, yoff), 0, 1, margin, 3 * margin);
    //line(0, y_left, width, y_right);
    println(y + " " + y_left + " " + y_right);    
    yoff += inc;
    horz_lines[curr][0] = new PVector(0, y_left);
    horz_lines[curr][1] = new PVector(width, y_right);
    curr++;
  }
  
  yoff = 0;
  inc = 0.2;
  // Now draw each line
  for (int i = 0; i < horz_lines.length; i++) {
    color pal = palette[floor(random(0, 4.99))];
    float y_delta = horz_lines[i][1].y - horz_lines[i][0].y;
    float xoff = 0;

    for (float x = 0; x < width; x += step) {
      float y = horz_lines[i][0].y + y_delta * x / width;
      println(y);
      stroke(pal, map(noise(xoff, yoff, 50), 0, 1, 90, 100));
      strokeWeight(step);
      float top_y = y + map(noise(xoff, yoff, 0), 0, 1, 0, thickness);
      float bottom_y = y - map(noise(xoff, yoff, 100), 0, 1, 0, thickness);
      line(x, top_y, x, bottom_y);
      xoff += inc;
    }
    yoff += inc;
  }
  
  // Now for vert lines
  
  float xoff = 0;
  stroke(0, 10);
  curr = 0;
  for (int x = 0; x < width; x+= x_scl) {
    float x_top = x + map(noise(xoff, 1), 0, 1, 0, x_scl/2);
    float x_bottom = x + map(noise(xoff, height), 0, 1, x_scl/2, x_scl);
    line(x_top, 0, x_bottom, height);
    xoff += 0.5;
    vert_lines[curr][0] = new PVector(x_top, 0);
    vert_lines[curr][1] = new PVector(x_bottom, height);
    curr++;
  }
  
  xoff = 0;
  inc = 0.2;
  // Now draw each line
  for (int i = 0; i < vert_lines.length; i++) {
    color pal = palette[floor(random(0, 4.99))];
    float x_delta = vert_lines[i][1].x - vert_lines[i][0].x;
    yoff = 0;
    for (float y = 0; y < height; y += step) {
      float x = vert_lines[i][0].x + x_delta * y / height;
      stroke(pal, map(noise(xoff, yoff, 50), 0, 1, 90, 100));
      strokeWeight(step);
      float left_x = x + map(noise(xoff, yoff, 0), 0, 1, 0, thickness);
      float right_x = x - map(noise(xoff, yoff, 100), 0, 1, 0, thickness);
      line(left_x, y, right_x, y);
      xoff += inc;
    }
    yoff += inc;
  }
  
}
