color[] palette;
int MAX_TILE_WIDTH = 40;
int MAX_TILE_HEIGHT = 40;
Board board;
ColorPalette PAL_A;
float PERSISTENCE = 0.5f;   
float FILL_THRESHOLD = 0.1;
float NOISE_SCALE = 1;
float PADDING = 10;

color BACKGROUND_COLOR = #FFFFFF;
int NPOINTS = 20;
float OPACITY = 40;
int LAYERS = 5;

void setup() {  
  generatePalettes();
  board = new Board(0, 0, 80, 80, 10);
  board.fillBoard();
  size(800, 800);
  noLoop();
}

void generatePalettes() {
  palette = new color[5];
  
  // fraserburgh

  palette[0] = #c64830;
  palette[1] = #fbd67d;
  palette[2] = #598b42;
  palette[3] = #aca68c;
  palette[4] = #a0acb8;
  
  PAL_A = new ColorPalette(palette);
}

void draw() {
  background(BACKGROUND_COLOR);
  //scale(0.25);
  board.render();
}

boolean isPixelOccupied(int x, int y) {
  loadPixels();
  int addr = x + y * width;
  color col = pixels[addr];
  if (red(col) == 255 && green(col) == 255 && blue(col) == 255)
    return false;
  return true;
}

boolean isRectOccupied(int x, int y, int w, int h) {
  for (int r = y; r < y + h; r++) {
    for (int c = x; c < x + w; c++) {
      if (isPixelOccupied(c, r)) 
        return true;
    }
  }
  return false;
}

PShape radiallyDeformedPolygon(float x, float y, float radius, int npoints, color colour, float opacity) {
  float [][] radials = baseRadials(npoints, radius);
  int num_deformations = 3;
  int i = 0;
  float[][] deformed_radials = radials;
  while (i < num_deformations) {
    deformed_radials = deformRadials(deformed_radials);
    i++;
  }
  return finalPolygon(x, y, deformed_radials, colour, opacity);
}

PShape finalPolygon(float x, float y, float[][] radials, color colour, float opacity) {
  fill(colour, opacity);
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

class Tile {
  int x, y;
  float tileSize;
  
  Tile (int x, int y, float ts) {
    this.x = x;
    this.y = y;
    this.tileSize = ts;
  }
}

class TileRect {
  float x, y;
  int w, h;
  color c;
  float tileSize;
  
  TileRect(float x, float y, int w, int h, color c, float tileSize) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.tileSize = tileSize;
    this.c = c;
  }
  
  boolean place(Tile[][] b) {
    if (checkIsValid(b)) {
        for (float cx = x; cx < x + w; cx++) {
            for (float cy = y; cy < y + h; cy++) {
                b[(int)cy][(int)cx] = new Tile((int)cx, (int)cy, tileSize);
            }    
        }
        return true;
    }
    return false;
  }

  boolean checkIsValid(Tile[][] b) {
    if (x + w > b[0].length) {
      return false;
    }
    if (y + h > b.length) {
      return false;
    }
    for (int cx = (int) x; cx < x + w; cx++) {
      for (int cy = (int) y; cy < y + h; cy++) {
        if (b[cy][cx] != null) {
          return false; 
        }
      }    
    }    
    return true;     
  }
  
  void render() {
    float lX = x * tileSize;
    float lY = y * tileSize;
    float lW = w * tileSize;
    float lH = h * tileSize;

    println("in render");
    float n = noise(lX * NOISE_SCALE, lY * NOISE_SCALE);
    if (n > FILL_THRESHOLD) {
      renderBlob(lX, lY);
      //rect(lX + PADDING, lY + PADDING, lW - PADDING, lH - PADDING);
    } else {
      stroke(this.c);
      noFill();
      //rect(lX + PADDING, lY + PADDING, lW - PADDING, lH - PADDING);
    }
  }
  
  void renderBlob(float lX, float lY) {
    noStroke();
    float lW = w * tileSize;
    float lH = h * tileSize;
        
    float sx = lX + tileSize/2;
    float sy = lY + tileSize/2;
    float base_radius = lW/8;
    
    int layers = LAYERS;
    float opacity = OPACITY;
    
    for (int j=0; j < layers; j++) {
      PShape poly;
      poly = radiallyDeformedPolygon(sx, sy, base_radius, NPOINTS, this.c, opacity);
      shape(poly);
      base_radius = base_radius + 2;
      opacity = opacity - 1;
    }
  }
}

class Board {
  float x, y;
  int rows;
  int cols;
  float tileSize;
  Tile[][] board;
  ArrayList<TileRect> rects = new ArrayList<TileRect>();

  Board(float x, float y, int r, int c, float tileSize) {
    this.x = x;
    this.y = y;    
    rows = r;
    cols = c;
    board = new Tile[rows][cols];  
    this.tileSize = tileSize;
  }

  TileRect tryPlaceTile(int startX, int startY, int startWidth, int startHeight) {
    TileRect tr = new TileRect(startX, startY, startWidth, startHeight,  PAL_A.getRandomColor(), tileSize);  
       while (startWidth > 0 && startHeight > 0) {
          if (tr.checkIsValid(board)) {
              tr.place(board);
              return tr;
          }
          // Decrement the width and height to check for smaller tile sizes.
          if (startWidth > 1) startWidth--;
          if (startHeight > 1) startHeight--;
          tr.w = startWidth;
          tr.h = startHeight;
      }
      return null;  // No valid placement was found.
  }


  void render() {
    for (TileRect tr : rects) {
      tr.render();
    }
  }
  void fillBoard() {
    for (int ty = 0; ty < board.length; ty++) {
      for (int tx = 0; tx < board[ty].length; tx++) {
        if (board[ty][tx] == null) {            
          TileRect tr = tryPlaceTile(tx, ty, (int)random(4, MAX_TILE_WIDTH), (int)random(4, MAX_TILE_HEIGHT));
          if (tr != null) {
            rects.add(tr);                  
          }         
        }    
      }
    }     
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
}
