// Classic Flying Saucer UFO Model
// A traditional dome-on-disc design

// Set $fn to 32 for preview, 128 for final print.
$fn = $preview ? 32 : 128;

// UFO Parameters
main_disc_radius = 50;
main_disc_height = 5;
dome_radius = 25;
dome_height = 15;

// String hole parameters
string_hole_radius = 0.6;

// U-shaped string hole module
module string_hole() {
    rotate([270, 0, 90])  
        rotate_extrude(angle=175, convexity=2)
            translate([2, 0, 0])
                circle(r=string_hole_radius);
}

// Main UFO assembly
module ufo() {
    difference() {
        union() {
            // Main disc body
            translate([0, 0, main_disc_height/2])
                cylinder(h=main_disc_height, r1=main_disc_radius, r2=main_disc_radius*0.1, center=true);
            
            translate([0, 0, -main_disc_height/2])
                cylinder(h=main_disc_height, r1=main_disc_radius*0.1, r2=main_disc_radius, center=true);

            // Top dome
            translate([0, 0, main_disc_height/2])
                scale([1, 1, 0.3])
                    color("red")sphere(r=dome_radius * 0.7);
        }
        
        translate([0, 0, main_disc_height*1.59]) // 1.59 is a magic number. Sry.
            difference() {
                string_hole();
        }
    }
}

ufo();
