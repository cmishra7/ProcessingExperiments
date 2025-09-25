// Boxes p5.js app
// Draws N filled rectangles in a 400x400 space
// Color palette: d0cecf, c1693c, eb862a, 77bfb3, 385f5b
// Press 'r' to regenerate

let rectangles = [];
let numRectangles = 25; // default value
let colorPalette = ['#d0cecf', '#c1693c', '#eb862a', '#77bfb3', '#385f5b'];

// Get N from URL parameters (simple command line simulation for web)
function getURLParameter(name) {
  const urlParams = new URLSearchParams(window.location.search);
  return urlParams.get(name);
}

function setup() {
  createCanvas(400, 400);

  // Check for N parameter in URL
  const nParam = getURLParameter('n') || getURLParameter('N');
  if (nParam) {
    numRectangles = parseInt(nParam) || 25;
  }

  generateRectangles();
}

function draw() {
  background(255);

  // Draw all rectangles
  for (let rect of rectangles) {
    fill(rect.color);
    noStroke();
    rect(rect.x, rect.y, rect.w, rect.h);
  }
}

function generateRectangles() {
  rectangles = [];

  for (let i = 0; i < numRectangles; i++) {
    let newRect = {
      x: random(0, width - 50), // Ensure rectangle fits in canvas
      y: random(0, height - 50),
      w: random(10, 50), // Min 10px, max 50px width
      h: random(10, 50), // Min 10px, max 50px height
      color: random(colorPalette)
    };

    // Ensure rectangle doesn't exceed canvas bounds
    newRect.w = min(newRect.w, width - newRect.x);
    newRect.h = min(newRect.h, height - newRect.y);

    rectangles.push(newRect);
  }
}

function keyPressed() {
  if (key === 'r' || key === 'R') {
    generateRectangles();
  }
}