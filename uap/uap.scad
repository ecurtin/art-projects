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
string_hole_radius = 2;

// U-shaped string hole module
module string_hole(radius) {
    rotate([90, 0, 90])  
        rotate_extrude(angle=180, convexity=2)
            translate([dome_height, 0, 0])
                circle(r=radius);
}


module ufo_body(){
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


// Main UFO assembly
module ufo() {
    union() {

        difference() {
            ufo_body();
            translate([0, 0, 27]){
                sphere(r=20);
            }
        }
        

        translate([0, 0, main_disc_height*0.625]) { // 1.59 is a magic number. Sry.
            difference() {
                scale([0.2, 1, 0.3]){
                    color("blue")string_hole(string_hole_radius-1.5);
                }
            }
        }
    }
}

ufo();
