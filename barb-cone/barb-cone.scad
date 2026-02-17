// include <BOSL2/std.scad>

// // --- Parameters ---
// cone_h = 25;          
// cone_d = 7;          
// ring_outer_d = 5;     
// ring_thickness = 1;   
// barb_rows = 4;        
// barbs_per_row = 6;    
// barb_size = [3, 1, 3]; 

// $fn = 64;             

// module barbed_cone() {
//     union() {
//         // 1. The Main Cone
//         cylinder(h=cone_h, d1=cone_d, d2=2);

//         // 2. The Top Ring
//         move([0, 0, cone_h+(ring_outer_d/3)])
//         rotate([90, 0, 0])
//         torus(d_maj=ring_outer_d, d_min=ring_outer_d - (ring_thickness * 2));

//         // 3. The Barbs
//         for (i = [1 : barb_rows]) {
//             z_pos = (cone_h / (barb_rows + 2)) * i;
//             current_r = (cone_d / 2) * (1 - z_pos / cone_h);
            
//             zrot_copies(n=barbs_per_row) 
//             move([current_r, 0, z_pos])
//             rotate([0, 45, 0]) 
//             prismoid(size1=[barb_size.x, barb_size.y], size2=[0, barb_size.y], h=barb_size.z, anchor=LEFT);
//         }
//     }
// }

// // --- Layout for Printing ---

// // We rotate it 90 degrees on the Y axis to lay it down, 
// // and then use left_half() to slice it down the middle.
// rotate([0, -90, 0]) 
// front_half() 
// barbed_cone();

// rotate([90, -90, 90])
// move([0, 0, -(cone_h+(ring_outer_d/1.06))*2]) 
// back_half() 
// barbed_cone();

// cube([2, 2, 2], )


include <BOSL2/std.scad>

// --- Parameters ---
cone_h = 25;          
cone_d = 7;          
ring_outer_d = 5;     
ring_thickness = 1;   
barb_rows = 4;        
barbs_per_row = 6;    
barb_size = [3, 1, 3]; 

// Pin/Dowel Parameters
pin_d = 1.6;          // Diameter of the separate pin
pin_h = 4;            // Total length of the pin
pin_dist = 10;        // Spacing between holes
slop = 0.15;          // Extra room in the hole for the pin to fit

$fn = 64;             

// 1. The Core Geometry (With Holes)
module barbed_cone_with_holes() {
    diff("hole") {
        union() {
            // Main Cone
            cylinder(h=cone_h, d1=cone_d, d2=2);

            // Top Ring
            move([0, 0, cone_h+(ring_outer_d/3)])
            rotate([90, 0, 0])
            torus(d_maj=ring_outer_d, d_min=ring_outer_d - (ring_thickness * 2));

            // Barbs
            for (i = [1 : barb_rows]) {
                z_pos = (cone_h / (barb_rows + 2)) * i;
                current_r = (cone_d / 2) * (1 - z_pos / cone_h);
                zrot_copies(n=barbs_per_row) 
                    move([current_r, 0, z_pos])
                    rotate([0, 45, 0]) 
                    prismoid(size1=[barb_size.x, barb_size.y], size2=[0, barb_size.y], h=barb_size.z, anchor=LEFT);
            }
        }

        // Define the holes on the Y-axis (the split line)
        tag("hole") {
            move([0, 0, (cone_h/2) + (pin_dist/2)]) rotate([90, 0, 0])
                cyl(d=pin_d + slop, h=pin_h + 1, anchor=CENTER);
            
            move([0, 0, (cone_h/2) - (pin_dist/2)]) rotate([90, 0, 0])
                cyl(d=pin_d + slop, h=pin_h + 1, anchor=CENTER);
        }
    }
}

// 2. The Separate Pin Module
module alignment_pin() {
    // A simple cylinder, slightly chamfered at the ends for easier insertion
    cyl(d=pin_d, h=pin_h, chamfer=0.2, anchor=BOTTOM);
}

// --- Layout for Printing ---

// Front Half
move([-8, 0, 0]) 
rotate([90, 0, 0]) 
front_half() 
barbed_cone_with_holes();

// Back Half
move([8, 0, 0]) 
rotate([-90, 0, 0]) 
back_half() 
barbed_cone_with_holes();

// Two Pins
move([0, -8, 0]) alignment_pin();
move([0, 8, 0]) alignment_pin();
