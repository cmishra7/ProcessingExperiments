PShape[] polygons;
float radius = 75;
float opacity = 20;

void setup() {
  randomSeed(7);
  size(400, 400, P3D);
  noStroke();
  polygons = new PShape[20];
  for (int i = 0; i < polygons.length; i++) {
    PShape poly;
    int[] orange = { 204 + int(random(50)), 102 + int(random(100)), 0 + int(random(200))};
    //int[] orange = { int(random(255)), int(random(255)), int(random(255)) };
    println(orange[0] + " " + orange[1] + " " + orange[2]);
    poly = polygon(0, 0, radius, 20, orange);
    radius = radius + 5;
    opacity = opacity - 1;
    for (int j = 0; j<3; j++) {
      poly = deformPoly(poly);
    }
    polygons[i] = poly;
  }
}

void draw() {
  background(255);
  translate(width/2, height/2, 0);
  for(int i = 0; i < polygons.length; i++)
    shape(polygons[i]);
}

PShape polygon(float x, float y, float radius, int npoints, int[] colours) {
  float angle = TWO_PI / npoints;
  fill(colours[0], colours[1], colours[2], opacity);
  PShape s = createShape();
  s.beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    s.vertex(sx, sy);
  }
  s.endShape(CLOSE);
  return s;
}

PShape deformPoly(PShape s) {
  PShape deformed = createShape();
  deformed.beginShape();
  for (int i = 0; i < s.getVertexCount(); i++) {
    PVector v = s.getVertex(i);
    deformed.vertex(v.x, v.y);
    PVector v_next = s.getVertex((i+1)%s.getVertexCount());
    float ratio = random(1);
    
    float distance = random(-radius/5, radius/5);

    deformed.vertex(
      v.x * ratio + v_next.x*(1-ratio) + distance,
      v.y * ratio + v_next.y*(1-ratio) + distance
     );
  }
  deformed.endShape(CLOSE);
  return deformed;
}
