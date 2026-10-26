
// Tux Twist-Lock Headband — parametric prototype
// Units: millimetres. Designed for FDM printing; fit must be tested on your printer.
// Copyright (c) 2026
// SPDX-License-Identifier: MIT
//
// Export a part with OpenSCAD CLI, e.g.
// openscad -o stl/headband_socket.stl -D 'part="headband_socket"' tux_twistlock.scad
// Supported part values: "headband_socket", "male_adapter", "assembly_preview", "fit_coupon"

$fn = 96;

// ---------- User-adjustable dimensions ----------
part = "assembly_preview";

head_radius = 82;          // approximate centreline radius of front half-band
band_radial_width = 18;    // width in plan view
band_thickness = 3.2;      // vertical thickness
arc_start = 35;            // degrees, mirrored around front centreline
arc_end = 145;

socket_outer_d = 27;
socket_inner_d = 18.6;     // 0.4 mm diametral clearance around 18.2 mm plug core
socket_height = 9.0;
socket_floor = 2.0;
slot_width = 4.4;
lug_outer_d = 22.4;
lug_tangential_width = 4.0;
lug_height = 2.0;
lock_angle = 35;
channel_z = 0.95;        // channel bottom from socket floor; aligns with lugs when seated
channel_height = 2.5;
adapter_flange_d = 29;
adapter_flange_h = 3.0;
plug_core_d = 18.2;
plug_length = 8.0;
plug_bottom_z = 1.0;       // lug bottom relative to plug base
fit_coupon_size = 32;

// ---------- Helpers ----------
module arc_band_2d(r, width, start_a, end_a) {
    // A continuous annular sector with radial end faces.
    difference() {
        intersection() {
            circle(r = r + width/2);
            polygon(points = concat(
                [[0,0]],
                [for (a = [start_a:1:end_a]) [(r + width/2)*cos(a), (r + width/2)*sin(a)]]
            ));
        }
        intersection() {
            circle(r = r - width/2);
            polygon(points = concat(
                [[0,0]],
                [for (a = [start_a:1:end_a]) [(r - width/2)*cos(a), (r - width/2)*sin(a)]]
            ));
        }
    }
}

module headband_solid() {
    linear_extrude(height = band_thickness)
        arc_band_2d(head_radius, band_radial_width, arc_start, arc_end);
}

module platform_and_socket() {
    // Platform sits on top of the headband at its front-centre.
    translate([0, head_radius, band_thickness])
    union() {
        cylinder(d = 32, h = 2.2);
        translate([0,0,2.0])
        difference() {
            cylinder(d = socket_outer_d, h = socket_height);
            // Main bore
            translate([0,0,socket_floor])
                cylinder(d = socket_inner_d, h = socket_height + 0.2);
            // Two vertical lug-entry slots. They open from the socket top down to channel level.
            for (a = [0,180]) {
                rotate([0,0,a])
                    translate([lug_outer_d/2, 0, (socket_floor + channel_z + channel_height + socket_height)/2])
                        cube([8, slot_width, socket_height - (socket_floor + channel_z + channel_height)], center=true);
            }
            // Horizontal bayonet channels, swept around lock_angle from each entry.
            for (a0 = [0,180]) {
                for (ang = [0:2:lock_angle]) {
                    rotate([0,0,a0+ang])
                        translate([lug_outer_d/2, 0, socket_floor + channel_z + channel_height/2])
                            cube([8, slot_width, channel_height], center=true);
                }
            }
        }
    }
}

module headband_socket() {
    union() {
        headband_solid();
        platform_and_socket();
    }
}

module male_adapter() {
    // Separate printable adapter: glue or mechanically fasten its flat flange to Tux underside.
    // The plug core and two opposing lugs mate with the female bayonet channels.
    union() {
        // Plug points downward from the flange: z=0 is the tip of the plug.
        cylinder(d = plug_core_d, h = plug_length);
        for (a = [0,180]) {
            rotate([0,0,a])
                translate([lug_outer_d/2 - 1.5, 0, plug_bottom_z + lug_height/2])
                    cube([3.0, lug_tangential_width, lug_height], center=true);
        }
        translate([0,0,plug_length - 0.2])
            cylinder(d = adapter_flange_d, h = adapter_flange_h + 0.2);
    }
}

module fit_coupon() {
    // Quick print-fit gauge: core ring and a pair of slots to check XY clearance.
    difference() {
        cylinder(d = socket_outer_d, h = 8);
        translate([0,0,1]) cylinder(d = socket_inner_d, h = 8);
        for (a = [0,180]) {
            rotate([0,0,a])
                translate([lug_outer_d/2,0,5])
                    cube([socket_outer_d, slot_width, 6], center=true);
        }
    }
}

module assembly_preview() {
    // Preview is a visual arrangement, not a single printable body.
    color("black") headband_socket();
    translate([0, head_radius, band_thickness + 2.2 + socket_floor + 0.2])
        color("orange") rotate([0,0,lock_angle]) male_adapter();
}

if (part == "headband_socket") {
    headband_socket();
} else if (part == "male_adapter") {
    male_adapter();
} else if (part == "fit_coupon") {
    fit_coupon();
} else {
    assembly_preview();
}
