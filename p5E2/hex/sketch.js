// Hexagon tiling with random colors
const CANVAS_SIZE = 400;
const HEX_SIDE = 10;
const colorPalette = [
  '#d0cecf',
  '#c1693c',
  '#eb862a',
  '#77bfb3',
  '#385f5b'
];

let hexagons = [];

function setup() {
  let canvas = createCanvas(CANVAS_SIZE, CANVAS_SIZE);
  canvas.parent('canvas-container');

  // Calculate hexagon dimensions
  const hexHeight = HEX_SIDE * 2;
  const hexWidth = Math.sqrt(3) * HEX_SIDE;
  const hexVerticalSpacing = hexHeight * 0.75;
  const hexHorizontalSpacing = hexWidth;

  // Generate hexagon positions
  hexagons = [];

  // Calculate how many rows and columns we need (with some buffer for partial hexagons)
  const rows = Math.ceil(CANVAS_SIZE / hexVerticalSpacing) + 2;
  const cols = Math.ceil(CANVAS_SIZE / hexHorizontalSpacing) + 2;

  for (let row = 0; row < rows; row++) {
    for (let col = 0; col < cols; col++) {
      let x = col * hexHorizontalSpacing;
      let y = row * hexVerticalSpacing;

      // Offset every other row for hexagon tiling pattern
      if (row % 2 === 1) {
        x += hexHorizontalSpacing / 2;
      }

      // Adjust starting position to center the pattern
      x -= hexHorizontalSpacing / 2;
      y -= hexVerticalSpacing / 2;

      // Only include hexagons that are at least partially visible
      if (x + hexWidth >= 0 && x - hexWidth <= CANVAS_SIZE &&
          y + hexHeight >= 0 && y - hexHeight <= CANVAS_SIZE) {
        hexagons.push({
          x: x,
          y: y,
          color: random(colorPalette)
        });
      }
    }
  }

  noLoop(); // Static image
}

function draw() {
  background(240);

  // Draw each hexagon
  for (let hex of hexagons) {
    fill(hex.color);
    stroke(255);
    strokeWeight(1);

    drawHexagon(hex.x, hex.y, HEX_SIDE);
  }
}

function drawHexagon(x, y, radius) {
  beginShape();
  for (let i = 0; i < 6; i++) {
    let angle = TWO_PI / 6 * i;
    let vx = x + cos(angle) * radius;
    let vy = y + sin(angle) * radius;
    vertex(vx, vy);
  }
  endShape(CLOSE);
}

// Redraw with new random colors when clicked or key pressed
function mousePressed() {
  // Reassign random colors
  for (let hex of hexagons) {
    hex.color = random(colorPalette);
  }
  redraw();
}

function keyPressed() {
  // Reassign random colors
  for (let hex of hexagons) {
    hex.color = random(colorPalette);
  }
  redraw();
}