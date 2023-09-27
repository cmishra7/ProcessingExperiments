color[] palette;
int MAX_TILE_WIDTH = 20;
int MAX_TILE_HEIGHT = 20;
Board board;
ColorPalette PAL_A;
float PERSISTENCE = 0.5f;   
float FILL_THRESHOLD = 0.4;
float NOISE_SCALE = 1;
float BOUNDARY = 4;

void setup() {  
  // fraserburgh
  palette = new color[5];
  palette[0] = #c64830;
  palette[1] = #fbd67d;
  palette[2] = #598b42;
  palette[3] = #aca68c;
  palette[4] = #a0acb8;
  
  PAL_A = new ColorPalette(palette);
  board = new Board(0, 0, 320, 480, 10);
  board.fillBoard();
  size(1200, 800);
  noLoop();
}

void draw() {
  background(255);
  scale(0.25);
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
    
    float n = noise(lX * NOISE_SCALE, lY * NOISE_SCALE);
    if (n > FILL_THRESHOLD) {
      stroke(255);
      fill(this.c);
    } else {
      stroke(this.c);
      noFill();
    }
    rect(lX + BOUNDARY, lY + BOUNDARY, lW - BOUNDARY, lH - BOUNDARY);
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
