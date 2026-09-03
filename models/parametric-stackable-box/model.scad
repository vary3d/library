/* [Dimensions] */

// Interior length of the box footprint.
body_x = 80; // [40:1:160]

// Interior width of the box footprint.
body_y = 110; // [60:1:200]

// Overall height, including the stacking lip.
body_z = 47; // [25:0.5:120]

// Wall thickness.
wall = 1.6; // [0.8:0.4:4]

/* [Rendering] */

// Hull render color.
body_color = "#2A9D90"; // color

include <geometry.scad>

color(body_color)
body();
