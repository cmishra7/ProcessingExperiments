// Hexagon tiling sketch for Express.js app
let colorPalette = ['#d0cecf', '#c1693c', '#eb862a', '#77bfb3', '#385f5b'];
let hexagons = [];

function setup() {
    // Create canvas and attach to container
    let canvas = createCanvas(400, 400);
    canvas.parent('canvas-container');

    // Calculate hexagon properties
    const sideLength = 10;
    const hexWidth = 2 * sideLength;
    const hexHeight = Math.sqrt(3) * sideLength;

    // Generate hexagon grid
    generateHexagonGrid(sideLength, hexWidth, hexHeight);

    // Initial draw
    drawHexagons();
}

function generateHexagonGrid(sideLength, hexWidth, hexHeight) {
    hexagons = [];

    const rowHeight = hexHeight * 0.75; // Vertical spacing between rows
    const colWidth = hexWidth; // Horizontal spacing between columns

    // Calculate how many rows and columns we need (with some buffer for edge cases)
    const numRows = Math.ceil(height / rowHeight) + 2;
    const numCols = Math.ceil(width / colWidth) + 2;

    for (let row = 0; row < numRows; row++) {
        for (let col = 0; col < numCols; col++) {
            // Calculate position
            let x = col * colWidth;
            let y = row * rowHeight;

            // Offset every other row for proper hexagonal tiling
            if (row % 2 === 1) {
                x += hexWidth / 2;
            }

            // Only add hexagons that are at least partially visible
            if (x > -hexWidth && x < width + hexWidth &&
                y > -hexHeight && y < height + hexHeight) {

                // Assign random color
                const color = random(colorPalette);

                hexagons.push({
                    x: x,
                    y: y,
                    sideLength: sideLength,
                    color: color
                });
            }
        }
    }
}

function drawHexagons() {
    background(240);

    // Draw each hexagon
    for (let hex of hexagons) {
        fill(hex.color);
        stroke('#000');
        strokeWeight(1);

        drawHexagon(hex.x, hex.y, hex.sideLength);
    }
}

function drawHexagon(centerX, centerY, sideLength) {
    beginShape();
    for (let i = 0; i < 6; i++) {
        const angle = (PI / 3) * i; // 60 degrees between each vertex
        const x = centerX + sideLength * cos(angle);
        const y = centerY + sideLength * sin(angle);
        vertex(x, y);
    }
    endShape(CLOSE);
}

function randomizeColors() {
    // Reassign random colors to all hexagons
    for (let hex of hexagons) {
        hex.color = random(colorPalette);
    }

    // Redraw
    drawHexagons();
}

// Alternative: Fetch new colors from server (demonstrates Express.js integration)
async function fetchNewColors() {
    try {
        const response = await fetch('/api/colors');
        const data = await response.json();
        colorPalette = data.colors;
        randomizeColors();
    } catch (error) {
        console.error('Error fetching colors:', error);
        // Fallback to local randomization
        randomizeColors();
    }
}

// Auto-randomize on page load
function draw() {
    // Static drawing - no animation needed
    noLoop();
}

// Key press for randomization (as in original)
function keyPressed() {
    randomizeColors();
}

// Mouse click for randomization (as in original)
function mousePressed() {
    randomizeColors();
}