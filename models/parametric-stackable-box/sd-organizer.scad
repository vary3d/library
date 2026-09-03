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

/* [Cards] */

// SD, microSD, or mixed. TF uses the microSD size. Mixed leaves a TF strip.
card = "sd"; // [sd:SD, microsd:microSD (TF), mixed:Mixed]

include <geometry.scad>

module sd_organizer() {
    if (part == "all") {
        color(tray_color) sd_tray();
        color(tray_color) body();
    } else if (part == "tray") {
        color(tray_color) sd_tray();
    } else if (part == "box") {
        color(tray_color) body();
    }
}

module sd_tray() {
    inset = wall + 1;
    rib = 1.5;
    side_indent = 3;
    rear_inset = 4;
    front_cut = front_edge_len + 6;

    sd_slot_x = 32.6;
    sd_slot_y = 2.8;
    sd_pitch_x = 35;
    sd_pitch_y = 4.6;
    sd_slot_z = 16;
    sd_reveal = 8;

    tf_slot_x = 15.6;
    tf_slot_y = 1.6;
    tf_pitch_x = 17.4;
    tf_pitch_y = 3.2;
    tf_slot_z = 8;
    band_gap = 2.4;

    is_tf = card == "microsd";
    is_mixed = card == "mixed";

    x_bound = body_x / 2 - side_indent - inset - rib;
    y_min = -body_y / 2 + front_cut;
    y_max = body_y / 2 - rear_inset - inset - rib;

    sd_x_lim = x_bound - sd_slot_x / 2;
    tf_x_lim = x_bound - tf_slot_x / 2;
    sd_y_min = y_min + sd_slot_y / 2;
    sd_y_max = y_max - sd_slot_y / 2;
    tf_y_min = y_min + tf_slot_y / 2;
    tf_y_max = y_max - tf_slot_y / 2;

    // Mixed: TF on +X, SD in what's left. Count never grows the box.
    tf_right = is_mixed ? tf_x_lim : (is_tf ? tf_x_lim : -1e9);
    tf_slot_left = tf_right - tf_slot_x / 2;
    tf_left_lim = is_mixed ? (tf_slot_left - band_gap) : (is_tf ? -tf_x_lim : -1e9);
    sd_right_lim = is_mixed ? (tf_left_lim - sd_slot_x / 2) : (is_tf ? -1e9 : sd_x_lim);
    sd_left_lim = -sd_x_lim;

    n_sd_x_fit = is_tf ? 0 : floor((sd_right_lim - sd_left_lim) / sd_pitch_x) + 1;
    n_sd_x = n_sd_x_fit <= 0 || sd_right_lim < sd_left_lim ? 0 : (
        (n_sd_x_fit - 1) * sd_pitch_x / 2 > (sd_right_lim - sd_left_lim) / 2
            ? n_sd_x_fit - 1 : n_sd_x_fit
    );
    n_sd_y_fit = floor((sd_y_max - sd_y_min) / sd_pitch_y) + 1;
    n_sd_y = n_sd_y_fit <= 0 ? 0 : (
        (n_sd_y_fit - 1) * sd_pitch_y > sd_y_max - sd_y_min ? n_sd_y_fit - 1 : n_sd_y_fit
    );

    n_tf_x_fit = is_tf ? floor((2 * tf_x_lim) / tf_pitch_x) + 1 : (is_mixed ? 1 : 0);
    n_tf_x = n_tf_x_fit <= 0 ? 0 : (
        is_mixed ? 1 : (
            (n_tf_x_fit - 1) * tf_pitch_x / 2 > tf_x_lim ? n_tf_x_fit - 1 : n_tf_x_fit
        )
    );
    n_tf_y_fit = floor((tf_y_max - tf_y_min) / tf_pitch_y) + 1;
    n_tf_y = n_tf_y_fit <= 0 ? 0 : (
        (n_tf_y_fit - 1) * tf_pitch_y > tf_y_max - tf_y_min ? n_tf_y_fit - 1 : n_tf_y_fit
    );

    well_z = is_tf ? tf_slot_z : sd_slot_z;
    tray_h = well_z + 1;

    sd_mid = (sd_left_lim + sd_right_lim) / 2;
    sd_x0 = n_sd_x <= 0 ? 0 : sd_mid - ((n_sd_x - 1) * sd_pitch_x) / 2;
    sd_y0 = n_sd_y <= 0 ? 0 : (sd_y_min + sd_y_max) / 2 - ((n_sd_y - 1) * sd_pitch_y) / 2;
    tf_mid = (tf_left_lim + tf_right) / 2;
    tf_x0 = n_tf_x <= 0 ? 0 : (
        is_mixed ? tf_x_lim : tf_mid - ((n_tf_x - 1) * tf_pitch_x) / 2
    );
    tf_y0 = n_tf_y <= 0 ? 0 : (tf_y_min + tf_y_max) / 2 - ((n_tf_y - 1) * tf_pitch_y) / 2;

    translate([0, 0, 2])
    difference() {
        linear_extrude(height = tray_h, center = !true, convexity = 10, twist = 0)
        rounding(r = 2)
        offset(delta = -inset)
        base();

        if (n_sd_x > 0 && n_sd_y > 0)
        for (i = [0:n_sd_x - 1]) {
            for (j = [0:n_sd_y - 1]) {
                x = sd_x0 + i * sd_pitch_x;
                y = sd_y0 + j * sd_pitch_y;
                if (abs(x) + sd_slot_x / 2 <= x_bound
                    && y - sd_slot_y / 2 >= y_min
                    && y + sd_slot_y / 2 <= y_max)
                translate([x, y, tray_h - sd_reveal])
                cube([sd_slot_x, sd_slot_y, sd_slot_z * 2], center = true);
            }
            if (n_sd_y >= 3)
            translate([
                sd_x0 + i * sd_pitch_x,
                sd_y0 + (n_sd_y - 1) * sd_pitch_y / 2,
                tray_h
            ])
            cube([sd_slot_x * 0.35, (n_sd_y - 3) * sd_pitch_y, 6], center = true);
        }

        if (n_tf_x > 0 && n_tf_y > 0)
        for (i = [0:n_tf_x - 1]) {
            for (j = [0:n_tf_y - 1]) {
                x = tf_x0 + i * tf_pitch_x;
                y = tf_y0 + j * tf_pitch_y;
                if (abs(x) + tf_slot_x / 2 <= x_bound
                    && y - tf_slot_y / 2 >= y_min
                    && y + tf_slot_y / 2 <= y_max)
                translate([x, y, tray_h - 3])
                cube([tf_slot_x, tf_slot_y, tf_slot_z * 2], center = true);
            }
        }

        translate([0, 3, 0])
        front_edge();
    }
}

sd_organizer();
