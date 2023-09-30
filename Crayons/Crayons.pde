  int cornerX = 100;
  int cornerY = 100;
  int WIDTH = 200;
  int HEIGHT = 200;

void setup() {
  size(400, 400);
  background(255);
}

void draw() {
  noFill();
  strokeWeight(8);

  rect(cornerX, cornerY, WIDTH, HEIGHT);
  
  strokeWeight(6);
  stroke(#365f63, 4);
  beginShape();
  int y = 5;
  for(int x = 5; x <= WIDTH; x += 20) {
    curveVertex(cornerX + x, cornerY);
    curveVertex(cornerX, cornerY + y);
    y += 20;
  }
  endShape();
  
}
