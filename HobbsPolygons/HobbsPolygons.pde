PShape[][] polygons;
int dim1 = 1000;
int dim2 = 800;

void setup() {
  size(1000, 800);
  float radius = 20;
  float opacity = 40;
  int num = 42;
  int layers = 20;
  int npoints = 20;
  noStroke();
  polygons = new PShape[num][layers];
  int[][] colours = new int[num][3];
  /*colours = {
    {204, 102, 0}, //orange
    {216, 191, 216}, //purple
    {120, 190, 33}, //lime_green
    {64, 224, 208} //turquoise.
  };*/
  
  //float[][] radial_centres = baseRadials(num, 300);
  
  float[][] centre_locations = generateGridCentres(dim1, dim2, 7, 6);

  
  for (int i = 0; i < num; i++) {
    //float sx = dim1/2 + cos(radial_centres[i][0]) * radial_centres[i][1];
    //float sy = dim2/2 + sin(radial_centres[i][0]) * radial_centres[i][1];
    
    //float sx = random(100, dim1 - 100);
    //float sy = random(100, dim2 - 100);
    
    float sx = centre_locations[i][0];
    float sy = centre_locations[i][1];

    int[] base_colour = {int(random(255)), int(random(255)), int(random(255))};
    float base_radius = radius;
    float base_opacity = opacity;
    for (int j=0; j < layers; j++){
      int[] permuted_colour = new int[3];
      for (int k=0; k< base_colour.length; k++) {
        permuted_colour[k] = permute_colour(base_colour[k]);
      }
      PShape poly;
      poly = radiallyDeformedPolygon(sx, sy, base_radius, npoints, permuted_colour, base_opacity);
      base_radius = base_radius + 2;
      base_opacity = base_opacity - 1;
      polygons[i][j] = poly;
    }
  }
}

void draw() {
  background(255);
  for(int i = 0; i < polygons.length; i++) {
    for (int j =0; j < polygons[i].length; j++) {
        shape(polygons[i][j]);
    }
  }
}

int permute_colour(int base) {
  return constrain(base + int(random(-100, 100)), 1, 255);
}

float[][] generateGridCentres(float dim1, float dim2, int num1, int num2) {
  int num = num1 * num2;
  float[][] centres = new float[num][2];
  float x_step = dim1/(num1 + 1);
  float y_step = dim2/(num2 + 1);
  int index = 0;
  float x_offset = x_step;
  for (int i = 0; i < num1; i++) {
    float y_offset = y_step;
    for (int j =0; j < num2; j++) {
      centres[index][0] = x_offset;
      centres[index][1] = y_offset;
      y_offset += y_step;
      index++;
    }
    x_offset += x_step;
  }
  return centres;
}

// Method : Radially deformed polygon.
// Construct base set of angles.
// Mess about with edges adding new vertices.
// Generate a final polygon and return.


PShape radiallyDeformedPolygon(float x, float y, float radius, int npoints, int[] colours, float opacity) {
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

PShape finalPolygon(float x, float y, float[][] radials, int[] colours, float opacity) {
  fill(colours[0], colours[1], colours[2], opacity);
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

// SCRATCHPAD
// Leaving below because I like the effect but I like the other one more.

// METHOD 1: polygon function + deformPoly function

/*PShape polygon(float x, float y, float radius, int npoints, int[] colours) {
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
}*/
