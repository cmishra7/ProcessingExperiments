ArrayList<Triangle> triangles;
color c = #fbd67d;
int dim = 3;

void setup() {
  size(1200, 800);
  background(255);
  
  triangles = new ArrayList<Triangle>();
  
  triangles.add(new Triangle(50, 50, 300, 75, 350, 390));
  
  int i = 0;
  while (i < 20) {
    addANewTriangle();
    i++;
  }
  
}

void addANewTriangle() {
  int index = floor(random(0, triangles.size()));
  Triangle t = triangles.get(index);;
  
  // choose a random vertex.
  int i = floor(random(0, 3));
  PVector v1 = t.getVertex(i);
  PVector v2 = t.getRandomPointOnLine(i);
  PVector v3 = v1.copy();
  v3.add(v2);
  v3.mult(random(0.5, 1));
  // Choose a third point at random;
  triangles.add(new Triangle(v1.x, v1.y, v2.x, v2.y, v3.x, v3.y));
  println("adding "+v1.x + " " +v1.y + " " +v2.x + " " +v2.y + " " + v3.x + " " + v3.y);
}

void draw() {
  noFill();
  if (frameCount == 1) {
    drawOutline();
  }
  /*if (frameCount < 300) {
    for (Triangle t: triangles) 
      t.drawRandomStroke();
  }
  if (frameCount == 300)
    println("done");
  */
  
}

void drawOutline() {
  stroke(c);
  for (Triangle t: triangles) 
    t.show();
}

class Triangle {
  PVector[] vertices;
  Triangle(float x1, float y1, float x2, float y2, float x3, float y3) {
    vertices = new PVector[3];
    vertices[0] = new PVector(x1, y1);
    vertices[1] = new PVector(x2, y2);
    vertices[2] = new PVector(x3, y3);
  }
  
  void show() {
    beginShape();
    for (int i = 0; i < vertices.length; i++) {
      vertex(vertices[i].x, vertices[i].y);
    }
    endShape(CLOSE);
  }
  
  PVector getVertex(int i) {
    return vertices[i].copy();
  }
  
  PVector getRandomPointOnLine(int i) {
    float x = random(0.3, 0.7);
    return new PVector(
      x * (float)vertices[i].x + (1-x) * (float) vertices[(i + 1)%3].x,
      x * (float)vertices[i].y+ (1-x) * (float) vertices[(i + 1)%3].y
    );
  }
  
  void drawRandomStroke() {
    int r = floor(random(0, dim));
    int a = floor(random(1, dim));
    PVector v1 = getRandomPointOnLine(r);
    PVector v2 = getRandomPointOnLine((r + a)%dim);
    strokeWeight(floor(random(2, 10)));
    stroke(c, floor(random(90, 100)));
    line(v1.x, v1.y, v2.x, v2.y);
  }
}
