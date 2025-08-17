// Set $fn to 32 for preview, 128 for final render.
$fn = $preview ? 32 : 128;
text = "this is some really cool text and i'll just go on and on and it's really long and this and that and stuff and things";
// Customizable sign with text
module custom_sign(
    size = [100, 30, 5],      // [width, height, thickness] of base
    border_height = 5,         // Height of the raised border
    border_width = 5,          // Width of the raised border
    text = text,
    text_size = 10,            // Initial text size (will be auto-scaled)
    text_font = "Arial:style=Bold" // Font to use
) {
    // Base plate
    cube(size);
    
    // Raised border
    difference() {
        // Outer cube for border
        translate([0, 0, size[2]])
            cube([size[0], size[1], border_height]);
        
        // Inner cutout for text area
        translate([border_width, border_width, size[2] - 0.1])
            cube([
                size[0] - 2 * border_width, 
                size[1] - 2 * border_width, 
                border_height + 0.2
            ]);
    }
    
    // Calculate text scale to fit within border
    text_width = len(text) * text_size * 0.6; // Rough estimate
    max_text_width = size[0] - 2 * border_width - 4; // Padding
    scale_factor = min(1, max_text_width / max(1, text_width));
    
    // Center text in the border area
    translate([size[0]/2, size[1]/2, size[2] + 0.1]) {
        linear_extrude(height = border_height) {
            text(
                text = text,
                size = text_size * scale_factor,
                font = text_font,
                halign = "center",
                valign = "center"
            );
        }
    }
}

// Example usage
custom_sign(
    size = [120, 40, 4],
    border_height = 6,
    border_width = 6,
    text = text
);
