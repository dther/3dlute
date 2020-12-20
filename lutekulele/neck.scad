include <src/BOSL/constants.scad>
use <src/BOSL/shapes.scad>
use <src/BOSL/masks.scad>

//Added to the fang inlay thingy to increase clearances between it and the neck block slot.
//SET TO 0 BEFORE PRINTING THE BODY!!!
neck_block_tolerance=1.5;

module neckbody(length=140, bottom_diameter=55, top_diameter=40, neck_block_tolerance=neck_block_tolerance) {
    union() {
    difference() {
        cyl(l=length, d1=bottom_diameter,d2=top_diameter, align=ALIGN_POS);
        //cut entire thing in half
        translate([-bottom_diameter/2, 0, -5]) cube([bottom_diameter+10,bottom_diameter+10,length+10]);
        // the fangs inlay thing
        translate([-15,0,0]) right_triangle(size=[15,10+neck_block_tolerance,10], orient=ORIENT_Y, align=V_FRONT+V_UP+V_LEFT);
        mirror([1,0,0]) translate([-15,0,0]) right_triangle(size=[15,10+neck_block_tolerance,10], orient=ORIENT_Y, align=V_FRONT+V_UP+V_LEFT);
        cuboid(size=[30+neck_block_tolerance,10+neck_block_tolerance,10+neck_block_tolerance], align=V_FRONT+V_UP);
        // pegbox slot
        translate([0,-6,130])rotate([70,0,0])difference() {
            prismoid(size1=[35,20], size2=[20,15], h=120);
            //need to truncate it a lil, it's cutting into the nut hole
            cuboid([35,20,10]);
            //TODO: mess with this if you ever plan on printing pegbox separately
        }
        //TODO: add bevel to allow easier fret tying
        // Need to do some trig to figure out the angle...
        // bevel mask is rotated because of neck taper
        bevel_rotation=-(90-atan(length/((bottom_diameter-top_diameter)/2)));
        chamfer_size=1;
        translate([bottom_diameter/2,0,0]) rotate([0,bevel_rotation,0]) chamfer_mask(l=length,chamfer=chamfer_size,align=ALIGN_POS);
        mirror([1,0,0]) translate([bottom_diameter/2,0,0]) rotate([0,bevel_rotation,0]) chamfer_mask(l=length,chamfer=chamfer_size,align=ALIGN_POS);
    }
    //maybe move this?
    translate([0,-6,130])rotate([70,0,0]) pegbox();
    }
}

module pegbox($fn=40) {
    difference() { //comment/uncomment to toggle peg visibility
        union() {
            difference() {
                prismoid(size1=[35,20], size2=[20,15], h=120);
                translate([-5,-10,0])cube([10,50,110]);
                //TODO: ???? agh!
                //translate([0,0,0]) rotate([180,180,0]) right_triangle([20,20,30], orient=ORIENT_X, align=ALIGN_POS);
                //add a fillet here to prevent string cuttin'
                //I have absolutely NO IDEA how this filleting mask works.
                //If you do, please send a pull request on how i can parameterise it better.
                translate([5,10,0]) fillet_mask_z(l=110,r=10,align=ALIGN_POS);
                mirror([1,0,0]) translate([5,10,0]) fillet_mask_z(l=110,r=10,align=ALIGN_POS);
            }
            //TODO: there's probably some kind of trigonometric way to figure out the pie slice angle.
            translate([0, -10, 1])pie_slice(ang=88, l=30, r=20, orient=ORIENT_X, center=true);
        }
        //TODO: turn this into a for loop
        translate([0,0,25]) rotate([0,-90,0]) peg(hole=19);
        translate([0,0,38]) rotate([0,90,0]) peg(hole=19);
        translate([0,0,51]) rotate([0,-90,0]) peg(hole=20);
        translate([0,0,64]) rotate([0,90,0]) peg(hole=20);
        translate([0,0,77]) rotate([0,-90,0]) peg(hole=21);
        translate([0,0,90]) rotate([0,90,0]) peg(hole=21);
        translate([0,0,103]) rotate([0,-90,0]) peg(hole=22);
    } //comment/uncomment this too
}

//d is the initial diameter and decreases
module taper(d=8) {
    //hmm. find some way of calculating this out...
    //cyl(l=30, d1=8, d2=7);
    cyl(l=45, d1=8, d2=6.8);
}

module peg(peg_d=8, head_d=15, join_d=10, peg_l=45, join_l=2, hole=25, hole_d=2) {
    // calculate 1:30 taper
    peg_d2 = peg_d-(peg_l/30);
    difference() {
        union() {
            cyl(l=peg_l, d1=peg_d, d2=peg_d2);
            //translate([0,0,-(peg_l/2+head_d/2)]) cyl(l=peg_d, d=head_d, orient=ORIENT_Y);
            //These should print better...
            //TOO SHARP TOO SHARP OW I HAVE LIKE 3 CUTS
            translate([0,0,-(peg_l/2+head_d/2)]) cuboid(size=[head_d,peg_d,head_d], fillet=head_d/7,
                    $fn=50);
            translate([0,0,-(peg_l/2)]) cyl(l=join_l, d=join_d);
        }
        translate([0,0,-(peg_l/2)+hole]) cyl(l=peg_d*2, d=hole_d, orient=ORIENT_Y, $fn=40);
    }
}

module nut(length=41) {
    difference() {
        cuboid(size=[length,5,4], align=V_BOTTOM+V_BACK);
        translate([0,1,4]) fillet_mask_x($fn=30, l=length,r=4, align=V_BOTTOM+V_BACK);
        //string holes
        between_courses=10;
        between_strings=2.5;
        string_width=1.5;
        //G
        translate([(length/2-3),5,0])#cyl(d=string_width,h=10,$fn=20);
        translate([(length/2-3)-between_strings,5,0])#cyl(d=string_width,h=10,$fn=20);
        //c
        translate([(length/2-3)-(between_strings+between_courses),5,0])#cyl(d=string_width,h=10,$fn=20);
        translate([(length/2-3)-(between_strings+between_courses)-between_strings,5,0])#cyl(d=string_width,h=10,$fn=20);
        //e
        translate([(length/2-3)-2*(between_strings+between_courses),5,0])#cyl(d=string_width,h=10,$fn=20);
        translate([(length/2-3)-2*(between_strings+between_courses)-between_strings,5,0])#cyl(d=string_width,h=10,$fn=20);
        //a
        translate([(length/2-3)-3*(between_strings+between_courses)+between_strings,5,0])#cyl(d=string_width,h=10,$fn=20);
    }
}

module nut_cut(length=41) {
    union() {
        cuboid(size=[length,5,4], align=V_BOTTOM+V_BACK);
        translate([0,1,4]) fillet_mask_x($fn=30, l=length,r=4, align=V_BOTTOM+V_BACK);
    }
}


//The whole neck, with supports

/*
difference(){
union(){
difference() {
    neckbody();
    //translate([0,0,30]) #cuboid(size=[200,150,200],align=V_FRONT+V_UP);//uncomment to print a "test piece" to test if it fits in the neck block slot
}
//fang thingy supports
translate([23,0,0]) cuboid(size=[5,10+neck_block_tolerance,1], align=V_FRONT+V_TOP);
mirror([1,0,0])translate([23,0,0]) cuboid(size=[5,10+neck_block_tolerance,1], align=V_FRONT+V_TOP);
}
difference() {
translate([0,-4,140]) nut_cut();
// nut cut support
translate([0,-4,140]) cuboid(size=[40,10,1],align=V_BOTTOM+V_BACK);
}
}
*/


//translate([0,-4,140]) nut();
//just the N U T
//nut();

// the pegs
        translate([0,0,0]) peg(hole=19);
        translate([20,0,0])peg(hole=19);
        translate([40,0,0]) peg(hole=20);
        translate([0,20,0])peg(hole=20);
        translate([20,20,0]) peg(hole=21);
        translate([40,20,0])peg(hole=21);
        translate([60,20,0])peg(hole=22);
