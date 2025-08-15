// Set $fn to 32 for preview, 128 for final render.
$fn = $preview ? 32 : 128;

render_delta = 1;

frame_width_total = 60;
frame_height = 60;
frame_thickness = 2.5;
frame_edge_width = 6;
hanger_distance_from_center = frame_width_total/4;
center_width = frame_width_total - frame_edge_width*2;
center_height = frame_height - frame_edge_width*2;
hole_radius = 2;
hole_distance_from_center = 40;

module hanging_frame(
    frame_width_total,
    frame_height,
    frame_thickness,
    frame_edge_width,
    hanger_distance_from_center,
    center_width,
    center_height,
    hole_radius,
    hole_distance_from_center
) {
    // Calculate half dimensions for easier positioning
    hfw = frame_width_total / 2;
    hfh = frame_height / 2;
    hcw = center_width / 2;
    hch = center_height / 2;
    
    difference() {
        // Main frame
        cube([frame_width_total, frame_height, frame_thickness], center=true);
        
        // Center cutout
        translate([0, 0, -render_delta/10])
            cube([center_width, center_height, frame_thickness + render_delta], center=true);
        
    }
    
    // Hanger protrusions - flat hollow cylinders on top edge
    for(x = [-1, 1]) {
        translate([x * hanger_distance_from_center, hfh - frame_thickness/2, 0]) {
            difference() {
                // Outer cylinder
                cylinder(h=frame_thickness, r=hole_radius * 2, center=true);
                // Inner hole
                cylinder(h=frame_thickness + render_delta, r=hole_radius, center=true);
            }
        }
    }
}

hanging_frame(
    frame_width_total, 
    frame_height, 
    frame_thickness, 
    frame_edge_width, 
    hanger_distance_from_center, 
    center_width, 
    center_height, 
    hole_radius, 
    hole_distance_from_center
);
