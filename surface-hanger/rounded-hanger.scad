$fn = $preview ? 32 : 128;

include <Round-Anything/polyround.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>


interior_depth = 45.2;
exterior_depth = 50.5;
rear_edge_height = 18.6;

arm_extension_past_surface = 120;
arm_rear_width = 30;
arm_surface_width = 4;
arm_thickness = 5;
surface_lip = 3;


module trapezoid_top_rounded(top, bottom, height, depth) {
    points=[
            [0,0], 
            [height, bottom/2-top/2], 
            [height, bottom/2+top/2], 
            [0, bottom]
        ];
    offset_sweep(points, height=depth, top=os_circle(r=2), steps=15);
}

module rectangle_top_rounded(length, width, depth, r=2){
    points=[
        [0,0],
        [length, 0],
        [length, width],
        [0, width]
    ];
    offset_sweep(points, height=depth, top=os_circle(r), steps=15);
}



module reference_surface() {
    union(){
        cube([500, interior_depth, rear_edge_height]);
        translate([0, interior_depth, -500 + rear_edge_height]){
            cube([500, exterior_depth - interior_depth, 500]);
        }
    }
}


// NOTE curvature_r must be >= 2*thickness_r
module hook(thickness_r, curvature_r, connecting_rod_height=80) {
    // cylindical entrance to hook
    translate([curvature_r/2,0,0]) 
       rotate([90,0,0]) cylinder(r=thickness_r,h=connecting_rod_height);
    
    // section curving opposite way of hook to connect to cylindrical entrance
    rotate_extrude(angle=90, convexity=10)
       translate([curvature_r/2, 0]) circle(thickness_r);
    
    // another straight cylinder connection to main hook
    translate([-curvature_r/2, curvature_r/2,0]) 
       rotate([0,90,0]) cylinder(r=thickness_r,h=curvature_r/2);
    
    // main "hook" of the hook"
    translate([-curvature_r*0.5,curvature_r*1.5,0])
       rotate_extrude(angle=270, convexity=10)
           translate([curvature_r, 0]) circle(thickness_r);
}


module back(thickness) {
    // back vertical piece sitting between wall and surface edge
    cube([arm_rear_width, thickness, rear_edge_height + thickness + thickness/2]);
}

module top(thickness) {
    translate([arm_rear_width, 0, rear_edge_height + arm_thickness]){
        rotate([0,0,90]) {
            trapezoid_top_rounded(
                arm_surface_width, 
                arm_rear_width, 
                //exterior_depth+thickness+surface_lip, 
                160,
                thickness
            );
            
        }
    }
}

module hanger_arm_back_and_top(thickness) {
    module back_and_top_hulled(thickness) {
        hull(){
            back(thickness);
            top(thickness);
        }
    }
    
    difference(){
        back_and_top_hulled(thickness);
        translate([-10, thickness, thickness])cube([500, interior_depth+30, rear_edge_height]);
    }
}

module hanger_arm(thickness=0) {
    
    // bottom piece that sits under the inside edge
    cube([arm_rear_width, interior_depth + thickness, thickness]);
    
    // back and top hulled together with interior space removed
    hanger_arm_back_and_top(thickness);

    // // surface lip
    // #translate([arm_rear_width/2-arm_surface_width/2, exterior_depth+thickness, rear_edge_height + thickness]){rotate([0, 90, 0]){
    //     linear_extrude(arm_surface_width)right_triangle([surface_lip, surface_lip]);
    // }}
    
    
    // extension arm
    // 1. connection to top and transition to cylinder
    hull(){
        translate(
            [arm_rear_width/2 + arm_surface_width/2,
             exterior_depth-thickness,
             rear_edge_height + thickness
        ]){
            rotate([0, 0, 90])
            rectangle_top_rounded(20, arm_surface_width, thickness, r=1.5);
        }
        
        translate(
            [arm_rear_width/2 - arm_surface_width/2 + thickness/2, 
             exterior_depth+thickness+surface_lip, 
             rear_edge_height + thickness+thickness/2]
        ){
            rotate([-90, 0, 0])
            cylinder(h = arm_extension_past_surface/4, d= arm_surface_width);
        }
    }
    
    // 2. tapering cylinder getting us to 90% of the length
    translate(
        [arm_rear_width/2 - arm_surface_width/2 + thickness/2, 
         exterior_depth+thickness+surface_lip+arm_extension_past_surface/4, 
         rear_edge_height + thickness+thickness/2]
    ){
        rotate([-90, 0, 0])
        cylinder(h = arm_extension_past_surface*0.65, r1 = arm_surface_width/2, r2 = arm_surface_width/2);
    }
    
    // 3. Hook at the last 10% of the length
    translate(
        [arm_rear_width/2 - arm_surface_width/2 + thickness/2, 
         exterior_depth+thickness+surface_lip+arm_extension_past_surface*.9, 
         rear_edge_height + thickness+thickness/10]
    ){
        rotate([0, -90, 0])
        hook(arm_surface_width/2, arm_surface_width, 10);
//        hook(1, 2, 10);

    }
    

}



//#translate([-100, arm_thickness, arm_thickness]){reference_surface();}

hanger_arm(arm_thickness);
