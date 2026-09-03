include <scad-utils/mirror.scad>
include <scad-utils/morphology.scad>

$fn = 30;

// Lip and front-scoop internals. Not Customizer knobs — each build root
// owns body_x / body_y / body_z / wall so the box and insert stay a split
// of one article in that file, not a cross-file Global kit.
holder_z_total = 10;
holder_z_joint = 3;
holder_delta = 2.4;
holder_clearance = 0.8;
front_edge_deg = 35;
front_edge_len = 20;
front_edge_top_deg = 30;
front_edge_top_len = 25;

module base(r = 1) {
    base_points = [
        [body_x / 2, 0],
        [0, 0],
        [0, body_y / 4],
        [3, body_y / 4 + 3],
        [3, body_y / 4 * 3 - 3],
        [0, body_y / 4 * 3],
        [0, body_y / 4 * 4],
        [0 + body_x / 3 - 3, body_y / 4 * 4],
        [0 + body_x / 3, body_y / 4 * 4 - 3],
        [body_x / 2, body_y / 4 * 4 - 3],
    ];

    points_centered = [for (p = base_points)
        [
            p[0] - body_x / 2,
            p[1] - body_y / 2
        ]
    ];

    points = concat(
        points_centered,
        [for (p = points_centered) [p[0] * -1, p[1]]]
    );

    rounding(r = r)
    polygon(points = points);
}

module body() {
    holder_z = holder_z_total - holder_z_joint;

    difference() {
        union() {
            // inner
            linear_extrude(height = body_z - holder_z_total, center = !true, convexity = 10, twist = 0)
            base();

            // joint
            translate([0, 0, body_z - holder_z])
            minkowski() {
                hull() {
                    linear_extrude(height = 0.01, center = !true)
                    rounding(r = 2 - 0.01)
                    square(size = [holder_delta * 2, holder_delta * 2], center = true);
                    translate([0, 0, -holder_z_joint])
                    sphere(r = 0.01);
                }

                linear_extrude(
                    height = 0.01,
                    center = !true,
                    convexity = 10
                )
                base();
            }

            // holder
            translate([0, 0, body_z - holder_z])
            linear_extrude(height = holder_z, center = !true, convexity = 10, twist = 0)
            offset(r = holder_delta)
            base();
        }

        // inner space
        difference() {
            translate([0, 0, 1])
            linear_extrude(height = body_z, center = !true, convexity = 10, twist = 0)
            offset(r = -wall)
            base();

            // frontEdge
            front_edge();
        }

        // holder inner space
        translate([0, 0, body_z - holder_z + 1])
        linear_extrude(height = holder_z, center = !true, convexity = 10, twist = 0)
        offset(r = holder_clearance)
        base();

        // front space
        translate([0, -body_y / 2, body_z / 2 + front_edge_len + 1])
        cube(size = [body_x - wall * 2, 10, body_z + 1], center = true);

        // frontEdge
        translate([0, -1 * sin(front_edge_deg), -1 * cos(front_edge_deg)])
        front_edge();

        // frontEdgeTop
        translate([0, -1 * sin(front_edge_top_deg), -1 * cos(front_edge_top_deg)])
        front_edge_top();
    }
}

module front_edge() {
    translate([0, -body_y / 2, 0])
    rotate([front_edge_deg, 0, 0])
    cube(
        size = [
            body_x + 10,
            front_edge_len * 2 * sin(front_edge_deg),
            front_edge_len * 2 * cos(front_edge_deg)
        ],
        center = true
    );
}

module front_edge_top() {
    translate([0, -body_y / 2, body_z])
    rotate([180 - front_edge_top_deg, 0, 0])
    cube(
        size = [
            body_x + 10,
            front_edge_top_len * 2 * sin(front_edge_top_deg),
            front_edge_top_len * 2 * cos(front_edge_top_deg)
        ],
        center = true
    );
}
