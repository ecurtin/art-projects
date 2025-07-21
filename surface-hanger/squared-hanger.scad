// Squared Hanger - Cube-based arm hanging device
// Based on rounded-hanger.scad but using only cube() primitives
include <BOSL2/std.scad>


// Surface parameters
interior_depth = 45.2;
exterior_depth = 50.5;
rear_edge_height = 18.6;

// These are parameters of the hanger.
arm_extension_past_surface = 120;
arm_rear_width = 30;
arm_surface_width = 4;
arm_thickness = 5;
surface_lip = 3;



module reference_surface() {
// This is the shape of the surface I'm hanging from. This doesn't go into the final piece, it's just here for reference.
// Use OpenSCAD's # comments to render this in a different color.
        union(){
            cube([500, interior_depth, rear_edge_height]);
            translate([0, interior_depth, -500 + rear_edge_height]){
                cube([500, exterior_depth - interior_depth, 500]);
            }
        }
    }

// Back vertical piece that sits against the wall
module back_piece(thickness) {
    cube([arm_rear_width, thickness, rear_edge_height + thickness]);
}

// Bottom piece that sits under the inside edge of the surface
module bottom_piece(thickness) {
    cube([arm_rear_width, interior_depth + thickness, thickness]);
}

// Top transition piece from back to surface edge
module top_piece(thickness) {
    // Main top piece extending from back to surface
    translate([0, 0, rear_edge_height + thickness]) {
        cube([arm_rear_width, exterior_depth + thickness + surface_lip, thickness]);
    }
}

// surface lip
module surface_lip(thickness){
#translate([arm_rear_width/2-arm_surface_width/2, exterior_depth+thickness, rear_edge_height + thickness]){rotate([0, 90, 0]){
    linear_extrude(arm_surface_width)right_triangle([surface_lip, surface_lip]);
}}
}

// Extension arm projecting out from the surface
module extension_arm(thickness) {
    // Main arm extending outward
    translate([(arm_rear_width - arm_surface_width)/2, exterior_depth + thickness + surface_lip, rear_edge_height + thickness]) {
        cube([arm_surface_width, arm_extension_past_surface * 0.8, thickness]);
    }
}

// Main hanger assembly
module squared_hanger(thickness = arm_thickness) {
    union() {
        back_piece(thickness);
        bottom_piece(thickness);
        top_piece(thickness);
        extension_arm(thickness);
        surface_lip(thickness);
    }
}

// Render the hanger
squared_hanger();

// Uncomment to show reference surface for context
translate([-100, arm_thickness, arm_thickness]) {
    color("blue") reference_surface();
}
