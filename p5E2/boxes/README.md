# Boxes P5.js App

A p5.js application that draws N filled rectangles in a 400x400 canvas.

## Features

- Draws configurable number of rectangles (default: 25)
- Rectangles can overlap
- Maximum rectangle size: 50px width/height
- Uses a specific color palette: d0cecf, c1693c, eb862a, 77bfb3, 385f5b
- Press 'r' key to regenerate rectangles

## Usage

Open `index.html` in a web browser.

To specify the number of rectangles, add a URL parameter:
```
index.html?n=50
```

## Controls

- Press 'r' or 'R' to regenerate rectangles with new random positions and colors

## Implementation Notes

Since this is a web-based p5.js app, command line parameters are simulated using URL parameters. The app checks for both 'n' and 'N' parameters in the URL to set the number of rectangles.