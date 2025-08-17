// Set $fn to 32 for preview, 128 for final render.
$fn = $preview ? 32 : 128;
// Customizable sign with text



// Thank you u/obscure3
// https://www.reddit.com/r/openscad/comments/3jwobs/comment/lvd2ex1/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
module multiLine(lines, size, leading){
  union(){
    for (i = [0 : len(lines)-1])
      translate([0 , -i * (size + leading), 0 ])
        text(lines[i], size, halign="center", valign="center");
  }
}

module multiLineSplit(line, size, leading){
    sep_ix = search(match_value = chr(10),                  // search indices of newline chars
                    string_or_vector = line,
                    num_returns_per_match = 0)[0];          // search returns array of matches!
    
    lines_ix = [ for (i = [0:len(sep_ix)])                  // build slice tuples
        i == 0 && i == len(sep_ix) ? [0,len(line)-1] :      // no matches, return whole line
        i == 0 ? [0,sep_ix[i]-1] :                          // first slice
        i == len(sep_ix) ? [sep_ix[i-1]+1,len(line)-1] :    // last slice
        [sep_ix[i-1]+1,sep_ix[i]-1] ];                      // everything in between

    lines_str = [ for (i = [0:len(lines_ix)-1])             // reconstruct slices as strings
        str(chr([ for (j = [lines_ix[i][0]:lines_ix[i][1]]) ord(line[j]) ])) ];

    multiLine(lines_str, size, leading);
}



module custom_sign(
    size = [100, 30, 5],      // [width, height, thickness] of base
    border_height = 1,         // Height of the raised border
    border_width = 2,          // Width of the raised border
    text = my_text,
    text_size = 10,            // Initial text size (will be auto-scaled)
    text_font = "Arial:style=Bold", // Font to use
    leading = 5
) {


    difference() {
        // Base plate
        cube(size);
        
            // Inner cutout for text area
        translate([border_width, border_width, size[2]-border_height])
            color("blue")cube([
                size[0] - 2 * border_width, 
                size[1] - 2 * border_width, 
                size[2]
            ]);
    }
    
    // Calculate text scale to fit within border
    text_width = len(text) * text_size * 0.6; // Rough estimate
    max_text_width = size[0] - 2 * border_width - 4; // Padding
    scale_factor = min(1, max_text_width / max(1, text_width));
    
    // Center text in the border area
    // translate([size[0]/2, size[1]/2, size[2] + 0.1]) {
        translate([0,0,0]) {

        linear_extrude(height = border_height) {
            multiLineSplit(text, text_size * scale_factor, leading);
        }
    }
}

my_text = "Follow\nYou're\nDetsiny";

// Example usage
custom_sign(
    size = [120, 40, 4],
    border_height = 1,
    border_width = 6,
    text = my_text,
    text_size = 10,
    text_font = "Arial:style=Bold",
    leading = 3);
