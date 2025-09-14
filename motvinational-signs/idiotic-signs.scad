// Set $fn to 32 for preview, 128 for final render.
$fn = $preview ? 32 : 128;
// Customizable sign with text



// Thank you u/obscure3
// https://www.reddit.com/r/openscad/comments/3jwobs/comment/lvd2ex1/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
function multiLineSplit(line) =
    let(
        sep_ix = search(match_value = chr(10),              // search indices of newline chars
                       string_or_vector = line,
                       num_returns_per_match = 0)[0],       // search returns array of matches
        
        lines_ix = [ for (i = [0:len(sep_ix)])              // build slice tuples
            len(sep_ix) == 0 ? [0, len(line)-1] :           // no matches, return whole line
            i == 0 && i == len(sep_ix) ? [0, len(line)-1] : // single line case
            i == 0 ? [0, sep_ix[i]-1] :                     // first slice
            i == len(sep_ix) ? [sep_ix[i-1]+1, len(line)-1] : // last slice
            [sep_ix[i-1]+1, sep_ix[i]-1] ],                  // everything in between
        
        // Reconstruct slices as strings
        lines_array = [ for (i = [0:len(lines_ix)-1])
            str(chr([ for (j = [lines_ix[i][0]:lines_ix[i][1]]) 
                ord(line[j]) 
            ]))
        ]
    )
    lines_array;  // Return the array of strings

module multiLine(my_text, size, font, leading, underline=false) {
    lines = multiLineSplit(my_text);
    total_height = (len(lines) - 1) * (size + leading);
    
    union() {
        // Original text
        for (i = [0 : len(lines) - 1]) {
            y_pos = total_height/2 - i * (size + leading);
            translate([0, y_pos, 0]) {
                text(
                    text = lines[i], 
                    size = size,
                    font = font,
                    halign = "center", 
                    valign = "center"
                );
                
                // Add underline if enabled
                if (underline) {
                    // Calculate text width (approximate)
                    text_width = len(lines[i]) * size * 0.6;
                    translate([0, -size/2 - 1, 0])  // Position below text
                        rectangle([text_width * 1.1, size * 0.1], center=true);
                }
            }
        }
    }
}

module sign_body(size, border_width, border_height){
    difference() {
        cube(size);
        translate([border_width, border_width, size[2]-border_height])
            color("blue")cube([
                size[0] - 2 * border_width, 
                size[1] - 2 * border_width, 
                size[2]
            ]);
    }
}



// Function to calculate required sign size based on text
function calculate_sign_size(text, text_size, border_width, thickness, leading, padding) =
    let(
        // Split text into lines
        lines = multiLineSplit(text),
        // Calculate width based on longest line
        max_line_length = max([for (line = lines) len(line)]),
        // Calculate dimensions
        text_width = max_line_length * text_size * 0.6,
        text_height = len(lines) * (text_size + leading) - leading,
        // Add padding
        width = text_width + padding + 2 * border_width,
        height = text_height + padding + 2 * border_width
    )
    [width, height, thickness];

module custom_sign_sized_to_text(
    text,                          // Text to display (with \n for newlines)
    text_size = 10,               // Text size in mm
    font = "Arial",
    border_height = 1,             // Height of the raised border
    border_width = 2,              // Width of the border
    thickness = 5,                 // Thickness of the sign
    leading = 3,                   // Space between lines
    padding = 15                    // Padding around text
) {
    // Calculate required sign size
    size = calculate_sign_size(text, text_size, border_width, thickness, leading, padding);
    
    // Create the sign body
    difference() {
        sign_body(size, border_width, border_height);

        // you need the min() for printing really small tests
        thumbtack_placement = min(size[1]*0.85, size[1]-4.2);

        // hole for hanging
        union() {
            translate([size[0]/2, thumbtack_placement-4, -0.01])
                cylinder(r1 = 4, r2 = 7, h = size[2]*0.5);
            translate([size[0]/2, thumbtack_placement, -0.01])
                cylinder(r1 = 2, r2 = 4, h = size[2]*0.5);
        }
    }


    // Position and render the text
    translate([size[0]/2, size[1]/2, size[2] - border_height]) {
        linear_extrude(height = border_height) {
            multiLine(text, text_size, font, leading);
        }
    }

}

module custom_sign_fixed_size(
    size = [100, 50, 5],        // [width, height, thickness] of the sign
    text,                        // Text to display (with \n for newlines)
    font = "Arial",             // Font to use
    border_height = 1,           // Height of the raised border
    border_width = 2,            // Width of the border
    leading = 3,                 // Space between lines
    text_size = 1,           // Text size (prevents text from becoming too small)
    underline = false) 
{
    // Calculate available space for text
    text_area_width = size[0] - 2 * border_width - 4;
    text_area_height = size[1] - 2 * border_width - 4;
    
    // Create the sign body
    difference() {
        sign_body(size, border_width, border_height);

        // Hole for hanging
        thumbtack_placement = min(size[1] * 0.85, size[1] - 4.2);
        union() {
            translate([size[0]/2, thumbtack_placement-4, -0.01])
                cylinder(r1 = 4, r2 = 7, h = size[2]*0.5);
            translate([size[0]/2, thumbtack_placement, -0.01])
                cylinder(r1 = 2, r2 = 4, h = size[2]*0.5);
        }
    }
    
    // Position and render the text with auto-scaling
    translate([size[0]/2, size[1]/2, size[2] - border_height]) {
        linear_extrude(height = border_height) {
            // // Start with a reasonable text size and scale down if needed
            // text_size = min(max_text_size, min(
            //     text_area_width / (len(text) * 0.6),  // Width-based size
            //     text_area_height / (len(multiLineSplit(text)) * (1 + leading/10))  // Height-based size
            // ));

            
            // Render the text with calculated size
            multiLine(text, text_size, font, leading, underline);
        }
    }
}

// Example usage with text that will be scaled to fit
// my_text = "Fallow\nYou're\nDetstiny";
// // Option 1: Sign sized to text
// custom_sign_sized_to_text(
//     text = my_text,
//     text_size = 30,
//     font = "Twinkle Star:style=Regular",
//     border_height = 1,
//     border_width = 6,
//     thickness = 6,
//     leading = 25,
//     padding = 30
// );




// my_text = "CLICK\nHERE";
// custom_sign_fixed_size(
//     size = [70, 70, 6],  // Fixed size
//     text = my_text,
//     font = "Impact:style=Regular",
//     border_height = 1,
//     border_width = 6,
//     leading = 8,
//     text_size = 16,
//     underline = false
// );

// translate([100, 0, 0]){
// my_text = "ADD\nTO\nCART";
// custom_sign_fixed_size(
//     size = [70, 70, 6],  // Fixed size
//     text = my_text,
//     font = "Impact:style=Regular",
//     border_height = 1,
//     border_width = 6,
//     leading = 4,
//     text_size = 13,
//     underline = false
// );
// }

// translate([200, 0, 0]){
// my_text = "LIKE AND\nSUBSCRIBE";
// custom_sign_fixed_size(
//     size = [120, 70, 6],  // Fixed size
//     text = my_text,
//     font = "Impact:style=Regular",
//     border_height = 1,
//     border_width = 6,
//     leading = 8,
//     text_size = 16,
//     underline = false
// );
// }

// translate([350, 0, 0]){
// my_text = "RATE AND\nREVIEW";
// custom_sign_fixed_size(
//     size = [120, 70, 6],  // Fixed size
//     text = my_text,
//     font = "Impact:style=Regular",
//     border_height = 1,
//     border_width = 6,
//     leading = 8,
//     text_size = 16,
//     underline = false
// );
// }

translate([500
, 0, 0]){
my_text = "SMASH\nLIKE";
custom_sign_fixed_size(
    size = [120, 70, 6],  // Fixed size
    text = my_text,
    font = "Impact:style=Regular",
    border_height = 1,
    border_width = 6,
    leading = 8,
    text_size = 16,
    underline = false
);
}