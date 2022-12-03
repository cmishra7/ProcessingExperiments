PShape[] polygons;
float radius = 100;
float opacity = 40;

void setup() {
  randomSeed(97);
  size(600, 600, P3D);
  noStroke();
  polygons = new PShape[20];
  for (int i = 0; i < polygons.length; i++) {
    PShape poly;
    int[] orange = { 204 + int(random(50)), 102 + int(random(100)), 0 + int(random(200))};
    int[] purple = {216 + int(random(-25,25)),191 + int(random(-25,25)),216 +  int(random(-25,5))};
    int[] lime_green = {120 + int(random(-25,25)), 190 + + int(random(-25,25)),33 + + int(random(-25,25))};
    int[] turquoise = {64 + int(random(-25,25)) ,224 + int(random(-25,25)) ,208 + int(random(-25,25))};
    //int[] orange = { int(random(255)), int(random(255)), int(random(255)) };
    //println(orange[0] + " " + orange[1] + " " + orange[2]);
    poly = radiallyDeformedPolygon(0, 0, radius, 20, turquoise);
    radius = radius + 5;
    opacity = opacity - 1;
    /*for (int j = 0; j<3; j++) {
      poly = deformPoly(poly);
    }*/
    polygons[i] = poly;
  }
}

void draw() {
  background(255);
  translate(width/2, height/2, 0);
  for(int i = 0; i < polygons.length; i++) {
    shape(polygons[i]);
  }
}

// METHOD 1: polygon function + deformPoly function

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

// Method 2: Radially deformed polygon: Instead of creating one, create many.


PShape radiallyDeformedPolygon(float x, float y, float radius, int npoints, int[] colours) {
  float angle = TWO_PI / npoints;
  float [][] radials = new float[npoints][2];
  float a = 0;
  for (int i = 0; i < npoints; i++) {
    radials[i][0] = a;
    radials[i][1] = radius;
    a+= angle;
  }
  for (int i=0; i < radials.length; i++) {
    println("OA "+i+" "+radials[i][0]);
  }
  // Now we deform
  float[][] deformed_radials = deformRadials(deformRadials(deformRadials(radials)));
  fill(colours[0], colours[1], colours[2], opacity);
  PShape s = createShape();
  s.beginShape();
  for (int i = 0; i < deformed_radials.length; i++)
  {
    a = deformed_radials[i][0];
    float r = deformed_radials[i][1];
    float sx = x + cos(a) * r;
    float sy = y + sin(a) * r;
    s.vertex(sx, sy);
  }
  s.endShape(CLOSE);
  return s;
}

float[][] deformRadials(float[][] radials) {
  int npoints = radials.length;
  int new_size = npoints * 2;
  float[][] deformed_radials = new float[new_size][2];
  for (int i=0; i<npoints; i++) {
    deformed_radials[2*i][0] = radials[i][0];
    deformed_radials[2*i][1] = radials[i][1];
    float[] first_point = radials[i];
    float[] second_point = radials[(i+1)%npoints];
    float ratio = random(1);
    float first_angle = first_point[0];
    float second_angle = second_point[0];
    if (second_angle < first_angle) {
      second_angle += TWO_PI;
    }
    float new_angle = first_angle * ratio + second_angle * (1-ratio);
    if (new_angle > TWO_PI) {
      new_angle -= TWO_PI;
    }
    println("First angle "+first_point[0]+"Second angle "+second_point[0] + " NA " + new_angle);
    float tweak = random(0.8, 1.2);
    float new_radius = (first_point[1] + second_point[1]) * tweak / 2;
    //println(new_angle+" "+new_radius);
    deformed_radials[2*i + 1][0] = new_angle; 
    deformed_radials[2*i + 1][1] = new_radius; 
  }
  for (int i=0; i < deformed_radials.length;i++) {
    println(i+" "+deformed_radials[i][0]);
  }
  return deformed_radials;
}
