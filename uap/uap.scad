// Classic Flying Saucer UFO Model
// A traditional dome-on-disc design

// Parameters
main_disc_radius = 50;
main_disc_height = 5;
dome_radius = 25;
dome_height = 15;
rim_thickness = 3;
rim_height = 2;


// Main UFO assembly
module ufo() {
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
}

// Render the UFO
ufo();