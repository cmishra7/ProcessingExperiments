StringList images;
PImage c1;
PImage c2;
PImage c3;



void setup() {
  size(390, 844);

  c1 = loadImage("IMG_7183.PNG");
  c2 = loadImage("IMG_7184.PNG");
  c3 = loadImage("IMG_7186.PNG");

  
  noLoop();
}

void draw() {
  // Displays the image at its actual size at point (0,0)
  //tint(255, 40);
  //image(c1, 0, 0, c1.width/3, c1.height/3);
  
  //blendMode(DIFFERENCE);
  //image(c1, 0, 0, c1.width/3, c1.height/3);
  //image(c2, 0, 0, c2.width/3, c2.height/3);



  c2.blend(c1, 
    0, 0, 390*3, 844*3, 
    0, 0, 390*3, 844*3, 
    DIFFERENCE); 

  image(c2, 0, 0, c2.width/3, c2.height/3);
  
  float radius = 20;
  float opacity = 40;
  int npoints = 20;
  
  for (int i = 0; i < 1000; i++) 
  {
    int x = ceil(random(390));
    int y = ceil(random(840));
    
    color pix = get(x, y);
    
    if (red(pix) < 25.0 && blue(pix) < 25.0 && green(pix) < 25.0) {
      println("continuing");
      continue;
    }
    println(x," ",y," ",red(pix)," ",blue(pix)," ",green(pix));
    PShape poly;
    color c = color(204, 102, 0);
    poly = radiallyDeformedPolygon(x, y, radius, npoints, pix, opacity);
    shape(poly);

  }
  
    
  /*c2.blend(c1, 
    0, 0, 390*3, 844*3, 
    0, 0, 390*3, 844*3, 
    DIFFERENCE); // LIGHTEST
    
  image(c2, 0, 0, c1.width/3, c1.height/3);*/

}

PShape radiallyDeformedPolygon(float x, float y, float radius, int npoints, color colours, float opacity) {
  float [][] radials = baseRadials(npoints, radius);
  int num_deformations = 3;
  int i = 0;
  float[][] deformed_radials = radials;
  while (i < num_deformations) {
    deformed_radials = deformRadials(deformed_radials);
    i++;
  }
  return finalPolygon(x, y, deformed_radials, colours, opacity);
}

PShape finalPolygon(float x, float y, float[][] radials, color colours, float opacity) {
  fill(colours, opacity);
  PShape s = createShape();
  s.beginShape();
  for (int i = 0; i < radials.length; i++)
  {
    float a = radials[i][0];
    float r = radials[i][1];
    float sx = x + cos(a) * r;
    float sy = y + sin(a) * r;
    s.vertex(sx, sy);
  }
  s.endShape(CLOSE);
  return s;
}

float[][] baseRadials(int npoints, float radius) {
  float angle = TWO_PI / npoints;
  float [][] radials = new float[npoints][2];
  float a = 0;
  for (int i = 0; i < npoints; i++) {
    radials[i][0] = a;
    radials[i][1] = radius;
    a+= angle;
  }
  return radials;
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
    float tweak = random(0.8, 1.2);
    float new_radius = (first_point[1] + second_point[1]) * tweak / 2;
    deformed_radials[2*i + 1][0] = new_angle; 
    deformed_radials[2*i + 1][1] = new_radius; 
  }
  return deformed_radials;
}
