PVector[] points = new PVector[40];

void setup() {
  size(1000, 1000);
  for (int i = 0; i < points.length; i++) {
    points[i] = new PVector(random(width), random(height), random(0, 400));
  }
}

void draw() {
  loadPixels();
  int z = frameCount % 20;
  z *= 10;
  println(z);
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float[] distances = new float[points.length];
      for (int i = 0; i < points.length; i++) {
          float d = dist(x, y, z, points[i].x, points[i].y, points[i].z);
          distances[i] = d;
      }
      //int n = 1;
      float[] sorted = sort(distances);
      float r = map(sorted[0], 0, 100, 50, 155);
      float g = map(sorted[1], 0, 200, 50, 155);
      float b = map(sorted[2], 0, 200, 50, 155);

      int index = x + y * width;
      pixels[index]  = color(r, g, b);
    }
  }
  updatePixels();
  
  /*for (PVector v: points) {
    stroke (0, 255, 0);
    strokeWeight(8);
    point(v.x, v.y);
  }*/
  //noLoop();
}
