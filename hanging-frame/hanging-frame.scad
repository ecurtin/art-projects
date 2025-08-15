// Set $fn to 32 for preview, 128 for final render.
$fn = $preview ? 32 : 128;

render_delta = 1;


module hanging_frame(
    frame_width = 150,
    frame_height = 200,
    frame_thickness = 2.5,
    hanger_distance_from_center = 20,
    center_width = 100,
    center_height = 150,
    hole_radius = 2,
    hole_distance_from_center = 40
) {
    // Calculate half dimensions for easier positioning
    hfw = frame_width / 2;
    hfh = frame_height / 2;
    hcw = center_width / 2;
    hch = center_height / 2;
    
    difference() {
        // Main frame
        cube([frame_width, frame_height, frame_thickness], center=true);
        
        // Center cutout
        translate([0, 0, -render_delta/10])
            cube([center_width, center_height, frame_thickness + render_delta], center=true);
        
        // Hanging holes
        for(y = [-1, 1]) {
            translate([0, y * hole_distance_from_center, 0])
                cylinder(h=frame_thickness + render_delta, r=hole_radius, center=true);
        }
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

// Example usage (uncomment to see the frame)
hanging_frame();
