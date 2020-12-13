include <src/BOSL/shapes.scad>
include <src/BOSL/transforms.scad>
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
    translate([0, 0, 210]) union() {
        //NUT
        translate([0,-4,140]) nut();
        difference() {
            neckbody();
            difference() {
                translate([0,-4,140]) nut_cut();
                // nut cut support
                //translate([0,-4,140]) cuboid(size=[30,10,1],align=V_BOTTOM+V_BACK);
            }
        }
    }
}

module soundbar(l=65,thickness=3,height=10) {
    difference() {
        cuboid(size=[l, height, thickness], align=V_FRONT+V_UP+V_DOWN);
        //scallop
        translate([l/2,1,0]) cyl(d=height*4,h=thickness+2, align=V_FRONT+V_UP+V_DOWN);
        mirror([1,0,0]) translate([l/2,1,0]) cyl(d=height*4,h=thickness+2, align=V_FRONT+V_UP+V_DOWN);
    }
}

module bridge(length=70, course_width=5, string_height=5) {
    difference() {
        cuboid(size=[length,10,10], align=V_BACK+V_DOWN, chamfer=5,
                edges=EDGE_BOT_BK);
        //slots for strings
        xspread(l=50,n=4) cuboid(size=[course_width,string_height,25], align=V_BACK);
    }
}

difference() {
    union() {
        lutebody(70);
    }
    translate([0,-2,10]) difference() {
        lutebody(65);
        //neck block
        translate([0,0,195]) cuboid(size=[70,70,50], align=ALIGN_POS);
    }
    //Hole?
    translate([0,0,130])cyl(d=50, h=20, orient=ORIENT_Y);
    //View soundboard
    //translate([0,-70, 0]) cuboid(size=[200,100,300], align=ALIGN_POS);
    // Neck slot
    translate([0,0.00000001,0]) roughneck();
}

//roughneck();
//Bridge
// 50-5 to account for nut
translate([0,0,45]) bridge();
// Barring?
// TODO: INCREDIBLY HACKY AND GROSS PLEASE FIX
bar_dist=10;
translate([0,-2,200-bar_dist*1]) soundbar(l=90);
translate([0,-2,200-bar_dist*3]) soundbar(l=110);
translate([0,-2,200-bar_dist*5]) soundbar(l=125);
translate([0,-2,200-bar_dist*6]) soundbar(l=130);
translate([0,-2,200-bar_dist*7]) soundbar(l=135);
translate([0,-2,200-bar_dist*8]) soundbar(l=140);
translate([0,-2,200-bar_dist*9]) soundbar(l=145);
translate([0,-2,200-bar_dist*11.5]) soundbar(l=150);
translate([0,-2,200-bar_dist*14]) soundbar(l=145);
//Treble and bass bars
translate([-30,-2, 200-bar_dist*16.5]) rotate([0,-20,0]) cuboid($fn=10, size=[30,5,3],align=V_FRONT+V_UP+V_DOWN, fillet=2.5, edges=EDGE_FR_RT+EDGE_FR_LF);
translate([-15,-2,200-bar_dist*17.5]) rotate([0,-60,0]) cuboid($fn=10, size=[25,5,3],align=V_FRONT+V_UP+V_DOWN, fillet=2.5, edges=EDGE_FR_RT+EDGE_FR_LF);
union() {
    translate([20,-2,200-bar_dist*17.5])cuboid(size=[30,5,3], $fn=10, edges=EDGE_FR_LF, fillet=2.5, align=V_FRONT+V_UP+V_DOWN);
    translate([41,-2,(200-bar_dist*17)+1.45])
            rotate([0,-45,0]) cuboid(size=[20,5,3], $fn=10, edges=EDGE_FR_RT, fillet=2.5, align=V_FRONT+V_UP+V_DOWN);
}
/*
translate([0,0,10]) difference() {
cylinder(h=370, d=35, $fn=100);
translate([-40, 0,0]) cube([100,100,1000]);
}*/

//luteshape2(10);

//scale length visualiser
//translate([0,0,45]) cyl(l=300, d=10, align=ALIGN_POS);
//
//String layout visualiser
//translate([0,0,45]) prismoid(size1=[55,5],size2=[37,5],h=300);
