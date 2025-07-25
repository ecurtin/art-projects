// Squared Hanger - Cube-based arm hanging device
// Based on rounded-hanger.scad but using only cube() primitives
include <BOSL2/std.scad>


// Surface parameters
interior_depth = 45.2;
exterior_depth = 50.5;
rear_edge_height = 18.6;

// These are parameters of the hanger.
arm_extension_past_surface = 120;
width = 5;
thickness = 5;
surface_lip_base = 3;
buttress_height = 5;
notch_depth = thickness/2;
notch_placement_percentage = 0.98;



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
    cube([width, thickness, rear_edge_height + thickness]);
}

// Bottom piece that sits under the inside edge of the surface
module bottom_piece(thickness) {
    cube([width, interior_depth + thickness, thickness]);
}

// Top transition piece from back to surface edge
module top_piece(thickness) {
    // Main top piece extending from back to surface
    translate([0, 0, rear_edge_height + thickness]) {
        cube([width, exterior_depth + thickness + surface_lip_base, thickness]);
    }
}

// surface lip
module surface_lip_base(thickness){
translate([0, exterior_depth+thickness, rear_edge_height + thickness]){rotate([0, 90, 0]){
    linear_extrude(width)right_triangle([surface_lip_base, surface_lip_base]);
}}
}

// Extension arm projecting out from the surface
module extension_arm(thickness) {
    rendering_delta = 1;
    difference(){
        // Main arm extending outward
        translate([0, exterior_depth + thickness + surface_lip_base, rear_edge_height + thickness]) {
            cube([width, arm_extension_past_surface, thickness]);
        }

        // Triangular notch
        translate([rendering_delta*-1, exterior_depth + thickness + surface_lip_base + arm_extension_past_surface*notch_placement_percentage, rear_edge_height + thickness*2 +rendering_delta*0.1
        ]){
            rotate([0, 90, 0]) {
                linear_extrude(width + rendering_delta*2) right_triangle([notch_depth, notch_depth]);
            }
        }
    }
}

// buttress triangle
module buttress(thickness){
    translate([0, 0, rear_edge_height + thickness*2 ]){
        rotate([90, 0, 90]) {
            triangle_base = arm_extension_past_surface*notch_placement_percentage + exterior_depth + surface_lip_base + thickness;
            triangle_height = buttress_height;
            linear_extrude(width) right_triangle([triangle_base, triangle_height]);
        }
    }
}


// Main hanger assembly
module squared_hanger(thickness) {
    union() {
        back_piece(thickness);
        bottom_piece(thickness);
        top_piece(thickness);
        extension_arm(thickness);
        surface_lip_base(thickness);
        buttress(thickness);
    }
}

// Render the hanger
squared_hanger(thickness);

// // Uncomment to show reference surface for context
// translate([-100, thickness, thickness]) {
//     color("blue") reference_surface();
// }
