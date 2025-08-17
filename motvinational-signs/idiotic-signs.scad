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

module multiLine(my_text, size, leading) {
    lines = multiLineSplit(my_text);
    union() {
        for (i = [0 : len(lines) - 1]) {
            translate([0, -i * (size + leading), 0]) {
                text(
                    text = lines[i], 
                    size = size, 
                    halign = "center", 
                    valign = "center"
                );
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
function calculate_sign_size(text, text_size, border_width, thickness, leading) =
    let(
        // Split text into lines
        lines = multiLineSplit(text),
        // Calculate width based on longest line
        max_line_length = max([for (line = lines) len(line)]),
        // Calculate dimensions
        text_width = max_line_length * text_size * 0.6,
        text_height = len(lines) * (text_size + leading) - leading,
        // Add padding
        width = text_width + 2 * border_width + 4,
        height = text_height + 2 * border_width + 4
    )
    [width, height, thickness];

module custom_sign(
    text,                          // Text to display (with \n for newlines)
    text_size = 10,               // Text size in mm
    border_height = 1,             // Height of the raised border
    border_width = 2,              // Width of the border
    thickness = 5,                 // Thickness of the sign
    leading = 3,                   // Space between lines
    padding = 4                    // Padding around text
) {
    // Calculate required sign size
    size = calculate_sign_size(text, text_size, border_width, thickness, leading);
    
    // Create the sign body
    sign_body(size, border_width, border_height);
    
    // Position and render the text
    translate([size[0]/2, size[1]/2, size[2] + 0.1]) {
        linear_extrude(height = border_height) {
            multiLine(text, text_size, leading);
        }
    }
}

my_text = "Follow\nYou're\nDetsiny";

// Example usage
custom_sign(
    text = my_text,
    text_size = 10,
    border_height = 1,
    border_width = 6,
    thickness = 4,
    leading = 3);
