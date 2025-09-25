const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files from public directory
app.use(express.static('public'));

// Route for the main hexagon tiling page
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// API endpoint to get random colors (simulates page reload randomization)
app.get('/api/colors', (req, res) => {
    const colors = ['#d0cecf', '#c1693c', '#eb862a', '#77bfb3', '#385f5b'];
    const randomizedColors = colors.sort(() => Math.random() - 0.5);
    res.json({ colors: randomizedColors });
});

app.listen(PORT, () => {
    console.log(`Hexagon Tiling App running on http://localhost:${PORT}`);
});

module.exports = app;