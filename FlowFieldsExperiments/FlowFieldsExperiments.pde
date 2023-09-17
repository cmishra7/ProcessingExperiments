float[][] grid;

int left_x;
int right_x;
int top_y;
int bottom_y;
int resolution;
int num_columns;
int num_rows;

final int LINE_SIZE = 5;

void setup() {
  size(800, 600);
  left_x = int(width * -0.1); 
  right_x = int(width * 1.1);
  top_y = int(height * -0.1);
  bottom_y = int(height * 1.1); 
  
  resolution = int(width * 0.02); 

  num_columns = (right_x - left_x) / resolution;
  num_rows = (bottom_y - top_y) / resolution;

  grid = new float[num_columns][num_rows];
  float default_angle = PI * 0.25;

  for (int column = 0; column < num_columns; column++) {
    for (int row = 0 ; row < num_rows; row++) {
      //grid[column][row] = default_angle;
      grid[column][row] = (row / float(num_rows)) * PI; 
    }
  }
  noLoop();
}

void draw() {
  for (int column = 0; column < num_columns; column++) {
    for (int row = 0 ; row < num_rows; row++) {
      float angle = grid[column][row];
      int x = left_x + column * resolution;
      int y = top_y + row * resolution;
      
      int end_x = x + int(LINE_SIZE * cos(angle));
      int end_y = y + int(LINE_SIZE * sin(angle));
      
      line(x, y, end_x, end_y);
      circle(end_x, end_y, 2);
    }
  }
  
}
