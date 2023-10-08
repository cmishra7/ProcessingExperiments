void setup() {
  size(1200, 800);
}

void draw() {
  noFill();
  background(225);
  scale(0.5);
  translate(400, 400);
  /*stroke(255, 102, 0);
  strokeWeight(10);
  point(120, 80);
  point(220, 90);
  point(220, 70);
  point(120, 75);
  //line(120, 80, 320, 20);
  //line(320, 300, 120, 300);
  stroke(0, 0, 0);
  //bezier(120, 80,  220, 90,  220, 71,  120, 75);
  
  beginShape();
  vertex(120, 80);
  bezierVertex(220, 90, 220, 70, 120, 75);
  bezierVertex(220, 80, 220, 60, 120, 65);
  endShape();*/
  
  strokeWeight(2);
  stroke(0);
  int x = 120;
  int y = 10;
  float xoff = 0;
  float inc = 0.2;
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
