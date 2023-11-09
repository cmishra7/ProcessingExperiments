ColorPalette PAL;

void setup() {
  size(878, 426);
  PAL = new ColorPalette();
  background(PAL.blue);
}

void draw() {
  noStroke();
  // Green rectangle vertical 0, 0 -> 14, 414
  fill(PAL.green);
  rect(0, 0, 14, 414);
  // Green rectangle horizontal  
  rect(0, 0, 221, 14);
  // Green rectangle horizontal  
  rect(400, 0, 440, 14);
  
  // LightBrown rectangle horizontal
  fill(PAL.lightbrown);
  rect(14, 14, 221 - 14, 14);
  rect(400, 14, 134, 14);
  
  fill(PAL.purple);
  rect(14, 28, 30, 386);

  // First bezier blob.
  drawARileyBlob(13, 364, PAL.lightbrown);
  drawARileyBlob(53, 324, PAL.green);
  drawARileyBlob(191, 346, PAL.purple);
  
  drawARileyBlob(674, 363, PAL.purple);
  drawARileyBlob(634, 403, PAL.green);
  drawARileyBlob(594, 443, PAL.purple);


  
  drawARileyBlob(501, 380, PAL.lightbrown);
  drawARileyBlob(461, 420, PAL.green);

  drawARileyBlob(280, 350, PAL.green);
  drawARileyBlob(240, 390, PAL.purple);

}

void drawARileyBlob(int x, int y, color c) {
  fill(c);
  beginShape();
  vertex(x, y);
  int anch_x = 1;
  int anch_y = 160;
  int w = 40;
  int tl_x = x+ 60;
  int tl_y = y - 250;
  bezierVertex(x- anch_x, y - anch_y, tl_x + anch_x, tl_y + anch_y, tl_x, tl_y);
  int tr_x = tl_x + w;
  int tr_y = tl_y - w ;
  vertex(tr_x, tr_y);
  int br_x = x + w;
  int br_y = y - w;
  bezierVertex(tr_x + anch_x, tr_y + anch_y, br_x - anch_x, br_y - anch_y, br_x, br_y);
  endShape(CLOSE);
}

class ColorPalette {
  color blue;
  color green;
  color purple;
  color darkbrown;
  color lightbrown;
  
  ColorPalette() {
    blue = color(121, 157, 208);
    green = color(93, 182, 124);
    darkbrown = color(168, 102, 35);
    lightbrown = color(196, 133, 105);
    purple = color(188, 168, 194);
  }
}
