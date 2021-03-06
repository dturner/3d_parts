JOISTING_WIDTH = 71;
JOISTING_HEIGHT = 52;
GUIDE_HEIGHT = 15;
GUIDE_THICKNESS = 3;

HOLE_SPACING = JOISTING_WIDTH / 2;
HOLE_DIAMETER = 5;
HOLE_OFFSET_FROM_CENTER = JOISTING_WIDTH / 4;


WASHER_DIAMETER = 10;
WASHER_THICKNESS = 2;



$fn = 40;
translate([0, GUIDE_THICKNESS, 0])
difference() {
    cube([JOISTING_WIDTH, JOISTING_HEIGHT, GUIDE_THICKNESS]);
    translate([JOISTING_WIDTH / 2 + HOLE_OFFSET_FROM_CENTER, JOISTING_HEIGHT/2, 0]) cylinder(d = HOLE_DIAMETER, h = GUIDE_THICKNESS);
    translate([JOISTING_WIDTH / 2 - HOLE_OFFSET_FROM_CENTER, JOISTING_HEIGHT/2, 0]) cylinder(d = HOLE_DIAMETER, h = GUIDE_THICKNESS);
}

difference() {
    union () {
     cube([JOISTING_WIDTH, GUIDE_THICKNESS, GUIDE_HEIGHT]);
     translate([0, JOISTING_HEIGHT + GUIDE_THICKNESS, 0]) cube([JOISTING_WIDTH, GUIDE_THICKNESS, GUIDE_HEIGHT]);
    }
    color("blue") translate([JOISTING_WIDTH / 2 - 1, 0, GUIDE_THICKNESS]) cube([2, JOISTING_HEIGHT + 2 * GUIDE_THICKNESS, GUIDE_HEIGHT - GUIDE_THICKNESS]);
}