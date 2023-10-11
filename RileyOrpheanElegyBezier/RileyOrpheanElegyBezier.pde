ColorPalette PAL_A;

int WOBBLE_FACTOR = 50;
int WIDTH = 700;
int CURVE_FACTOR = 50;
int HEIGHT = CURVE_FACTOR * 3 * 10;
int INC = 5;


// THESE CALCULATIONS ARE WEIRD BUT YOU WANT HEIGHT TO BE DIVISIBLE BY 3 * CURVE_FACTOR to

void setup() {
  size(600, 600);
  background(255);
  generatePalettes();
}

void generatePalettes() {
  color[] palette = new color[5];
  
  palette[0] = #aec9d2;
  palette[1] = #bfa6b6;
  palette[2] = #f6c894;
  palette[3] = #e9b488;
  palette[4] = #2e401e;
  
  PAL_A = new ColorPalette(palette);
}

void draw() {
  noLoop();
  noFill();
  float x,y;
  int inc = INC;
  translate(-20, -100);
  int i = 0;
  for (x = 0; x < WIDTH; x += inc) {
    println("starting an iteration");
    i++;
    fill(PAL_A.getColor(i));
    beginShape();
    y = 0;
    int wobblage = ((int)x) % WOBBLE_FACTOR;
    int wobble = min(wobblage, WOBBLE_FACTOR - wobblage);
    vertex(x, y);
    println("first vertex " + x + " " +y);
    for (y = 0; y < HEIGHT; y+=3 * CURVE_FACTOR) {
      bezierVertex(x-40, y + CURVE_FACTOR + wobble, x + 40, y + 2 * CURVE_FACTOR + wobble, x, y + 3 * CURVE_FACTOR + wobble);
      println("anchor vertex "+x + " " +  (y + 3 * CURVE_FACTOR + wobble));
    }
    
    wobblage = ((int)x + inc) % WOBBLE_FACTOR;
    wobble = min(wobblage, WOBBLE_FACTOR - wobblage);
    println("way back");
    println("vertex "+ (x + inc) + " " + (HEIGHT + wobble));
    float x2 = x + inc;
    vertex(x2, HEIGHT + wobble);
    
    for (y = HEIGHT; y > 0; y-=3*CURVE_FACTOR) {
      float anchor_y =  y - 3*CURVE_FACTOR + wobble;
      if (anchor_y < 3*CURVE_FACTOR) {
        anchor_y = 0;
      }
      bezierVertex(x2 + 40, y - CURVE_FACTOR + wobble, x2 - 40, y - 2 * CURVE_FACTOR + wobble, x2, anchor_y);
      println(" anchor vertex "+x2+ " " + anchor_y);
    }
    println("final vertex "+(x+inc) + " "+ 0);
    vertex(x + inc, 0);
    println("done");
    endShape(CLOSE);
  }
}

class ColorPalette {
  color[] colors;
  
  ColorPalette(color[] colors) {
    this.colors = colors;
  }
  
  color getRandomColor() {
    return colors[(int) random(colors.length)];
  }
  
  color getColor(int i) {
    return colors[i%colors.length];
  }
}
