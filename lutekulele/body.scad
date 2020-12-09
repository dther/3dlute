include <src/BOSL/shapes.scad>
use <src/BOSL/constants.scad>
use <neck.scad>

module luteshape(radius) {
    translate([0,radius,0]) union() {
        circle(radius);
        difference() {
            intersection() {
                translate([radius,0,0]) circle(2*radius);
                translate([-radius,0,0]) circle(2*radius);
            }
            translate([0,-radius,0]) square(radius*2, center=true);
        }
    }
}

module luteshape2(radius) {
    translate([0,radius,0]) union() {
        circle(radius);
        
        difference() {
        
            intersection() {
            
                translate([3*radius,0,0]) circle(4*radius);
                translate([-3*radius,0,0]) circle(4*radius);
            }
            translate([0,-2*radius,0]) square(radius*4, center=true);
        }
    }
}

module lutebody(radius) {
    rotate_extrude(angle=180, $fn=24) difference() {
        luteshape2(radius, $fn=360);
        square(radius*100);
    }
}

module roughneck() {
   translate([0, 0, 210]) neckbody(); 
}

difference() {
lutebody(70);
translate([0,-2,10])lutebody(65);
translate([0,0,130])cyl(d=60, h=20, orient=ORIENT_Y);
}
roughneck();
/*
translate([0,0,10]) difference() {
cylinder(h=370, d=35, $fn=100);
translate([-40, 0,0]) cube([100,100,1000]);
}*/

//luteshape2(10);
