/* [Rendering] */

// All = assembled preview. Pick a kind to export STL.
part = "all"; // [all:All, divider:Divider, box:Box]

// Hull render color.
divider_color = "#2A9D90"; // color

/* [Dimensions] */

// Interior length of the box footprint.
body_x = 80; // [40:1:160]

// Interior width of the box footprint.
body_y = 110; // [60:1:200]

// Overall height, including the stacking lip.
body_z = 47; // [25:0.5:120]

// Wall thickness. The divider follows this so it still fits the box in this file.
wall = 1.6; // [0.8:0.4:4]

/* [Divider] */

// Pockets along interior length.
grid_x = 2; // [1:1:6]

// Pockets along interior width.
grid_y = 2; // [1:1:6]

/* [Hidden] */

// Thickness of the divider walls.
org_wall = 2; // [0.8:0.4:4]

// Height of the rim around the insert.
org_frame_z = 3; // [1:0.5:12]

// Fit gap between the insert and the box wall.
org_clearance = 1; // [0.2:0.1:3]

include <geometry.scad>

module generic_organizer() {
    if (part == "all") {
        color(divider_color) divider_insert();
        color(divider_color) body();
    } else if (part == "divider") {
        color(divider_color) divider_insert();
    } else if (part == "box") {
        color(divider_color) body();
    }
}

module org_base() {
    rounding(r = 2)
    offset(delta = -wall - org_clearance)
    base();
}

module divider_insert() {
    min_cell = 12;
    gx = min(max(1, grid_x), max(1, floor(body_x / min_cell)));
    gy = min(max(1, grid_y), max(1, floor(body_y / min_cell)));
    org_wall_z = body_z * 0.7;
    // Split the usable field behind the scoop. Walls that span body_y
    // turn the front row into a scoop-cut shallow cell.
    y_lo = -body_y / 2 + front_edge_len + 6;
    y_hi = body_y / 2 - 4;
    y_span = y_hi - y_lo;

    translate([0, 0, 1])
    difference() {
        union() {
            linear_extrude(height = org_frame_z, center = !true, convexity = 10, twist = 0)
            shell(d = -3)
            org_base();

            linear_extrude(height = org_wall_z, center = !true, convexity = 10, twist = 0)
            intersection() {
                union() {
                    if (gx > 1)
                    for (i = [1:gx - 1])
                    translate([(i / gx - 0.5) * body_x, (y_lo + y_hi) / 2])
                    square(size = [org_wall, y_span], center = true);

                    if (gy > 1)
                    for (j = [1:gy - 1])
                    translate([0, y_lo + j * y_span / gy])
                    square(size = [body_x, org_wall], center = true);
                }
                org_base();
            }
        }

        translate([0, org_clearance, 0]) {
            front_edge();
            front_edge_top();
        }
    }
}

generic_organizer();
