// Classic Flying Saucer UFO Model
// A traditional dome-on-disc design

// Set $fn to 32 for preview, 128 for final print.
$fn = $preview ? 32 : 128;

// UFO Parameters
disc_radius = 50; //should be 50 in future designs
top_disc_height = 5;
bottom_disc_height = 6;

dome_radius = 25;
dome_squish_factor = 0.3;
cut_the_bottom_of_the_dome = true;

// String hole parameters
string_hole_radius = 2;
string_hole_thickness = 1.5;


// Flat string hole with center hole
module string_hole(radius, thickness) {
    rotate([0, 0, 90]) {
        difference() {
            // Outer flat cylinder
            cylinder(h=thickness, r=radius*1.5, center=true);
            
            // Center hole
            translate([0, 0, -radius+0.5])
                cylinder(h=radius*4, r=radius, center=true);
        }
    }
}

module dome(){
    translate([0, 0, 0])
        scale([1, 1, dome_squish_factor])
            color("red")sphere(r=dome_radius);
}

module ufo_body(){
    // top disk
    translate([0, 0, top_disc_height/2])
        cylinder(h=top_disc_height, r1=disc_radius, r2=disc_radius*0.1, center=true);
    
    // bottom disk
    translate([0, 0, -bottom_disc_height/2])
        cylinder(h=bottom_disc_height, r1=disc_radius*0.1, r2=disc_radius, center=true);

    // top dome
    if (cut_the_bottom_of_the_dome) {
        difference() {
            dome();
            // this is inordinately big but it's fine.
            translate([-disc_radius, -disc_radius,  -disc_radius])
                cube([disc_radius*2, disc_radius*2, disc_radius]);
        }
    } else {
        dome();
    }

}

module ufo() {
    union() {
        ufo_body();

        translate([0, 0, dome_radius*dome_squish_factor-(1*(1-dome_squish_factor                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ))]){
            color("blue")rotate([90, 0, 0])string_hole(string_hole_radius, string_hole_thickness);
        }
    }
}

ufo();
