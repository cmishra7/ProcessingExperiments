# Hexagon Tiling Express.js App

An Express.js web application that displays a 400×400 canvas tiled with hexagons using p5.js.

## Features

- **Express.js server** with static file serving and API endpoints
- **400×400 pixel canvas** tiled with hexagons
- **Hexagons with 10-pixel sides** arranged in proper hexagonal tiling pattern
- **Color palette**: `#d0cecf`, `#c1693c`, `#eb862a`, `#77bfb3`, `#385f5b`
- **Random color assignment** on page load
- **Interactive color randomization** via button clicks or key/mouse presses
- **API endpoint** (`/api/colors`) for server-side color randomization

## Installation

```bash
cd p5E2/hex
npm install
```

## Running the App

```bash
npm start
# or
node server.js
```

The app will be available at `http://localhost:3000`

## Tessl Usage Specs

This project follows the tessl framework specifications for Express.js and p5.js integration:

### Express.js Usage
- Server setup with static file serving
- RESTful API endpoints for dynamic content
- Proper error handling and middleware configuration

### p5.js Usage
- Canvas creation and DOM integration
- Mathematical calculations for hexagonal tiling
- Interactive user input handling
- Color randomization algorithms

## API Endpoints

- `GET /` - Serves the main hexagon tiling page
- `GET /api/colors` - Returns randomized color palette

## Project Structure

```
hex/
├── server.js          # Express.js server
├── package.json       # Node.js dependencies
├── README.md         # This file
└── public/
    ├── index.html    # HTML template
    └── sketch.js     # p5.js hexagon tiling logic
```

## Interaction

- **Click anywhere** on the canvas to randomize colors
- **Press any key** to randomize colors
- **Click "Randomize Colors"** button to randomize colors
- **Click "Reload Page"** button to refresh the entire page