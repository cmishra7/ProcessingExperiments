float xoff = 0;
float inc = 0.2;

void setup() {
  size(1200, 800);
}

void draw() {
  noLoop();
  noFill();
  background(225);
  scale(0.25);
  pushMatrix();
  translate(0, 400);
  drawVerticleSquiggleLine();
  drawAngledHorizontalSquiggles();
  popMatrix();
  pushMatrix();
  translate(300, 100);
  for (int i = 0; i < 1500; i+=50) {
    drawSquigglesAlongACurve(60, 1120 + i, 1560 + i, 960 + i, 940 + i, 340 + i, 1840 + i, 80);
  }
  popMatrix();
  pushMatrix();
  translate(3000, 2000);
  drawSquigglesBetweenTwoCurves();
  popMatrix();
  

}

void drawVerticleSquiggleLine() {
  strokeWeight(2);
  stroke(0);
  int x = 120;
  int y = 10;
  beginShape();
  vertex(x, y);
  while(y < 700) {
    float x1 = x + map(noise(xoff), 0, 1, 50, 150);
    xoff += inc;
    float y1 = y - 10 + map(noise(xoff), 0, 1, -2, 2);
    xoff += inc;
    float x2 = x + map(noise(xoff), 0, 1, 50, 150);
    xoff += inc;
    float y2 = y + 10 + map(noise(xoff), 0, 1, -2, 2);
    xoff += inc;
    float x3 = x + map(noise(xoff), 0, 1, -20, 20);
    xoff += inc;
    float y3 = y + 5 + map(noise(xoff), 0, 1, -2, 2);
    bezierVertex(x1, y1, x2, y2, x3, y3);
    y+=5;
  }
  endShape();
}

void drawAngledHorizontalSquiggles() {
  strokeWeight(2);
  stroke(0);
  int x,y;
  
  float rot = -PI/24;
  for (y = 700; y > 100; y -= 100) {
    pushMatrix();
    rotate(rot);
    x = 200;
    beginShape();
    vertex(x, y);
    while(x < 1100) {
      float y1 = y - map(noise(xoff), 0, 1, 50, 150);
      xoff += inc;
      float x1 = x - 10 + map(noise(xoff), 0, 1, -2, 2);
      xoff += inc;
      float y2 = y - map(noise(xoff), 0, 1, 50, 150);
      xoff += inc;
      float x2 = x + 10 + map(noise(xoff), 0, 1, -2, 2);
      xoff += inc;
      float y3 = y + map(noise(xoff), 0, 1, -20, 20);
      xoff += inc;
      float x3 = x + 5 + map(noise(xoff), 0, 1, -2, 2);
      bezierVertex(x1, y1, x2, y2, x3, y3);
      x+=5;
    }
    endShape();
    rot -= PI/48;
    popMatrix();
  }
}

void drawSquigglesAlongACurve(float px1, float py1, float cx1, float cy1, float cx2, float cy2, float px2, float py2) {
  stroke(255, 102, 0);
  strokeWeight(10);
  bezier(px1, py1, cx1, cy1, cx2, cy2, px2, py2);
  strokeWeight(2);
  int steps = 300;
  stroke(0);
  beginShape();
  vertex(px1, py1);
  for (int i = 0; i <= steps; i++) {
    /*if (i > 50 && i < steps - 50 && i%3 != 0) {
      // Weird effect but ok
      // Using this to make the central bit less dense
      continue;
    }*/
    float t = i / float(steps);
    float x0 = bezierPoint(px1, cx1, cx2, px2, t);
    float y0 = bezierPoint(py1, cy1, cy2, py2, t);
    
    float y1 = y0 - map(noise(xoff), 0, 1, 50, 150);
    xoff += inc;
    float x1 = x0 - 10 + map(noise(xoff), 0, 1, -10, 10);
    xoff += inc;
    float y2 = y0 - map(noise(xoff), 0, 1, 50, 150);
    xoff += inc;
    float x2 = x0 + 10 + map(noise(xoff), 0, 1, -10, 10);
    xoff += inc;
    float y3 = y0 + map(noise(xoff), 0, 1, -20, 20);
    xoff += inc;
    float x3 = x0 + 5 + map(noise(xoff), 0, 1, -10, 10);
    bezierVertex(x1, y1, x2, y2, x3, y3);
  }
  endShape();
}

void drawSquigglesBetweenTwoCurves() {
  stroke(255, 102, 0);
  strokeWeight(10);  
  curve(20, 594, 20, 0, 592, 196, 292, 0);
  curve(20, 760, 20, 760, 592, 592, 292, 96);
}
 
