/* [Rendering] */

// All = assembled preview. Pick a kind to export STL.
part = "all"; // [all:All, tray:Tray, box:Box]

// Hull render color.
tray_color = "#2A9D90"; // color

/* [Dimensions] */

// Interior length of the box footprint.
body_x = 80; // [40:1:160]

// Interior width of the box footprint.
body_y = 110; // [60:1:200]

// Overall height, including the stacking lip.
body_z = 47; // [25:0.5:120]

// Wall thickness. The tray follows this so it still fits the box in this file.
wall = 1.6; // [0.8:0.4:4]

/* [Battery] */

// Cell type. Well diameter is the cell plus 1 mm clearance.
battery = "aa"; // [aaa:AAA, aa:AA, 18650:18650]

/* [Hidden] */

// Pocket depth.
well_z = 8; // [4:0.5:20]

include <geometry.scad>

module battery_tray() {
    batt_d = battery == "aaa" ? 11.5 : battery == "18650" ? 19.6 : 15;
    pitch = batt_d + 1.5;
    inset = wall + 1;
    rib = 2;
    side_indent = 3;
    rear_inset = 4;
    front_cut = front_edge_len + 6;

    x_lim = body_x / 2 - side_indent - inset - batt_d / 2 - rib;
    y_min = -body_y / 2 + front_cut + batt_d / 2;
    y_max = body_y / 2 - rear_inset - inset - batt_d / 2 - rib;

    n_x_fit = floor((2 * x_lim) / pitch) + 1;
    n_x = max(1, (n_x_fit - 1) * pitch / 2 > x_lim ? n_x_fit - 1 : n_x_fit);
    n_y_fit = floor((y_max - y_min) / pitch) + 1;
    n_y = max(1, (n_y_fit - 1) * pitch > y_max - y_min ? n_y_fit - 1 : n_y_fit);
    x0 = -((n_x - 1) * pitch) / 2;
    y0 = (y_min + y_max) / 2 - ((n_y - 1) * pitch) / 2;

    translate([0, 0, 2])
    difference() {
        linear_extrude(height = well_z, center = !true, convexity = 10, twist = 0)
        rounding(r = 2)
        offset(delta = -inset)
        base();

        for (i = [0:n_x - 1]) {
            x = x0 + i * pitch;
            for (j = [0:n_y - 1])
            translate([x, y0 + j * pitch, -1])
            cylinder(d = batt_d, h = well_z + 2, center = !true);

            hull() {
                for (j = [0:n_y - 1])
                translate([x, y0 + j * pitch, -1])
                cylinder(d = batt_d / 2, h = well_z + 2, center = !true);
            }
        }

        translate([0, 3, 0])
        front_edge();
    }
}

module battery_organizer() {
    if (part == "all") {
        color(tray_color) battery_tray();
        color(tray_color) body();
    } else if (part == "tray") {
        color(tray_color) battery_tray();
    } else if (part == "box") {
        color(tray_color) body();
    }
}

battery_organizer();
