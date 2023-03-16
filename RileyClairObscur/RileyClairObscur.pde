// Bridget Riley Clair Obscur
// 29 + 2 * 0.5 triangles wide.
// 17 triangles high.

int[][][] triangles;

boolean[][] processedTriangles;
final int XSIZE = 40;
final int YSIZE = 34;
final int BOUNDARY = 40;
final int XNUM = 30;
final int YNUM = 17;
final float RIPPLING_RATE = 0.9;
final float IGNORE_FLIPPING_PREF_RATE = 0.1;

void settings() {
  size (XSIZE * 30 + BOUNDARY * 2, YSIZE * YNUM + BOUNDARY * 2);
}
void setup() {
  //size (1280,658);
  triangles = new int[XNUM  + 1][YNUM][6];
  for (int j=0; j < YNUM; j++) {
    for (int i = 0; i < XNUM  + 1; i++) {
      int x1 = XSIZE + i * XSIZE;
      if (j % 2 == 1) {
        x1 = x1 - XSIZE/2;
      }
      int y1 = XSIZE + YSIZE*YNUM - j*YSIZE;
      triangles[i][j][0] = x1;
      triangles[i][j][1] = y1;   
      triangles[i][j][2] = x1 + XSIZE;
      triangles[i][j][3] = y1;
      triangles[i][j][4] = x1 + XSIZE/2;
      triangles[i][j][5] = y1 - YSIZE;
    }
  }

  noLoop();
}

void draw() {
  drawInitialTriangles();
  recolourDarkTriangles();
  //drawClairObscurOriginal();
  //drawClairObscurInspired();
}

void drawInitialTriangles() {
  background(255);
  noStroke();
  fill(0, 0, 0);
  rect(XSIZE, XSIZE, XSIZE*XNUM, YSIZE*YNUM);
  fill(255, 255, 255);
  noStroke();
  for (int i = 0; i < XNUM  + 1; i++) {
    for (int j = 0; j < YNUM; j++) {
      int[] coords = triangles[i][j];
      triangle(coords[0], coords[1], coords[2], coords[3], coords[4], coords[5]);
    }
  }
}

void recolourDarkTriangles() {
  fill(64, 224, 208);
  noStroke();
  for (int i = 0; i < XNUM  + 1; i++) {
    for (int j = 0; j < YNUM; j++) {
      int[] coords = triangles[i][j];
      triangle(coords[0], coords[1], coords[2]  - 2 * XSIZE, coords[3] - YSIZE, coords[4], coords[5]);
    }
  }
}

// The original Clair Obscur set, done manually.
void drawClairObscurOriginal() {
  int [][] whiteArcs = { 
    {5,0},
    {1,1},{5,1},{7,1},{20,1},{22,1},{24,1},{29,1},
    {8,2},{10,2},{12,2},{15,2},
    {2,3},{4,3},{6,3},{7,3},{17,3},{21,3},{23,3},{25,3},{28,3},{30,3},
    {8,4},{10,4},{12,4},{19,4},{20,4},
    {5,5},{7,5},{8,5},{14,5},{17,5},{18,5},{19,5},{20,5},{26,5},{27,5},{29,5},
    {4,6},{7,6},{9,6},{10,6},{11,6},{13,6},{16,6},{21,6},
    {6,7},{9,7},{15,7},{16,7},{19,7},{21,7},{23,7},{26,7},{28,7},{30,7},
    {6,8},{8,8},{10,8},{12,8},{14,8},{17,8},{22,8},
    {1,9},{5,9},{7,9},{9,9},{13,9},{20,9},{22,9},{23,9},{24,9},{27,9},{29,9},
    {9,10},{11,10}, {17,10},
    {1,11},{6,11},{8,11},{10,11},{12,11},{14,11},{21,11},{25,11},{26,11},{28,11},{30,11},
    {16,12},
    {3,13},{5,13},{7,13},{9,13},{11,13},{13,13},{15,13},{20,13},{22,13},{24,13},{26,13},{27,13},{29,13},
    {8,14},{17,14},{19,14},
    {4,15},{6,15},{8,15},{12,15},{14,15},{16,15},{18,15},{21,15},{23,15},{25,15},{26,15},{28,15},{30,15},
    {5,16},{17,16},{19,16},{22,16}
  };
  for (int i = 0; i < whiteArcs.length; i++) {
    whiteArcify(whiteArcs[i][0], whiteArcs[i][1]);
  }
  int [][] blackArcs = {
    {12,1},
    {5,2},{20,2},{22,2},{24,2},{29,2},
    {8,3},{10,3},{12,3},
    {6,4},{17,4},{21,4},{23,4},{25,4},{28,4},
    {9,5},{11,5},{13,5},{15,5},
    {18,6},{22,6},{29,6},
    {8,7},{10,7},{12,7},{14,7},{17,7},
    {18,8},{21,8},{28,8},
    {17,9},
    {1,10},{3,10},{5,10},{7,10},{18,10},{20,10},{22,10},{24,10},{27,10},{29,10},
    {2,12}, {4,12}, {6,12}, {8,12}, {14,12}, {19,12}, {21,12}, {23,12}, {26,12}, {28,12},
    {3,14}, {5,14}, {7,14}, {9,14}, {15,14}, {20,14}, {22,14}, {24,14}, {27,14}, {29,14},
    {5,16}, {7,16}, {9,16}, {14,16}, {21,16}, {23,16}, {26,16}, {28,16}
  };
  for (int i = 0; i < blackArcs.length; i++) {
    blackArcify(blackArcs[i][0], blackArcs[i][1]);
  }
}

void drawClairObscurInspired() {
  processedTriangles = new boolean[XNUM+1][YNUM];
  final int NUM_ITERATIONS = 40;
  int iter = 0;
  while (iter < NUM_ITERATIONS) {
    int i = int(random(XNUM + 1));
    int j = int(random(YNUM));
    if (processedTriangles[i][j]) {
      continue;
    }
    ripple(i, j, false);
    iter++;
  }
}

void ripple(int i, int j, boolean preferBlack) {
  if (boundaryFail(i, j)) {
    return;
  }
  if (processedTriangles[i][j]) {
    return;
  }
  // Step 1: Choose which type of arc
  boolean ignorePref = (random(1) < IGNORE_FLIPPING_PREF_RATE);
  boolean newPreferBlack = false;
  if (preferBlack && ignorePref) {
    whiteArcify(i,j);
    newPreferBlack = true;
  } else if (!preferBlack && !ignorePref) {
    whiteArcify(i, j);
    newPreferBlack = true;
  } else {
    blackArcify(i, j);
    newPreferBlack = false;
  }
  processedTriangles[i][j] = true;
  
  if (random(1) < RIPPLING_RATE) {
    ripple(i+1, j+1, newPreferBlack);
    ripple(i-1, j-1, newPreferBlack);
  }
}

boolean boundaryFail(int i, int j) {
  if (i < 0 || i >= XNUM + 1 || j < 0 || j >= YNUM) {
    return true;
  }
  return false;
}

void whiteArcify(int i, int j) {
  int x = XSIZE + i * XSIZE + XSIZE;
  if (j % 2 == 1) {
    x = x - XSIZE/2;
  }
  int y = XSIZE + YSIZE * YNUM - j*YSIZE;
  fill(255, 255, 255);
  //fill(120, 190, 33);
  arc (x, y, 80, 80, PI, 4*PI/3, PIE);
}

void blackArcify(int i, int j) {
  if (i == 0 || i >= XNUM) {
    // cannot blackArcify right now
    return;
  }
  int x = i * XSIZE + XSIZE/2;
  if (j % 2 == 1) {
    x = x - XSIZE/2;
  }
  int y = XSIZE + YSIZE*YNUM - j*YSIZE -YSIZE;
  fill(0, 0, 0);
  //fill(64, 224, 208);
  arc (x, y, 80, 80, 0, PI/3, PIE);
}
