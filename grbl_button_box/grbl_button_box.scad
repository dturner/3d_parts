include <../common/roundedcube.scad>
include <../common/prism.scad>

EMERGENCY_BUTTON_DIAM = 30;
ABORT_BUTTON_DIAM = 18.5;
HOLD_BUTTON_DIAM = 18.5;
RESUME_BUTTON_DIAM = 18.5;
BOX_THICKNESS = 40;
BOX_SIDE_THICKNESS = 2;
BOX_TOP_THICKNESS = 3;
BOX_SIDE_SPACING = 10;
BOX_BUTTON_TOP_SPACING = 18;
BOX_BUTTON_BOTTOM_SPACING = 4;
BOX_BUTTON_SPACING = 8;

POWER_SWITCH_WIDTH = 19;
POWER_SWITCH_HEIGHT = 13;

FAN_SWITCH_WIDTH = 19;
FAN_SWITCH_HEIGHT = 13;

BOX_SWITCH_SPACING = 8;

LED_DIAMETER = 5;

CABLE_DIAMETER = 8;
CABLE_BOTTOM_OFFSET = 5;
CABLE_HOLES_SPACING = 30;

BOX_PANEL_ANGLE = 17;

/* Generated */
BOX_FULL_WIDTH = 2 * BOX_SIDE_SPACING + 3 * BOX_BUTTON_SPACING + EMERGENCY_BUTTON_DIAM + ABORT_BUTTON_DIAM + HOLD_BUTTON_DIAM + RESUME_BUTTON_DIAM + 2 * BOX_SWITCH_SPACING + POWER_SWITCH_WIDTH +  FAN_SWITCH_WIDTH;
BOX_FULL_HEIGHT = EMERGENCY_BUTTON_DIAM + BOX_BUTTON_TOP_SPACING + BOX_BUTTON_BOTTOM_SPACING;

echo("Box full width: ", BOX_FULL_WIDTH);

BOX_PANEL_OFFSET = tan(BOX_PANEL_ANGLE) * BOX_FULL_HEIGHT;

module button_box_block() {
    difference() {
        roundedcube([BOX_FULL_WIDTH, BOX_FULL_HEIGHT, BOX_THICKNESS], true, 3, "z");
        translate([0, 0, BOX_THICKNESS - BOX_PANEL_OFFSET/2]) rotate([BOX_PANEL_ANGLE, 0, 0]) cube([BOX_FULL_WIDTH, BOX_FULL_HEIGHT*2, BOX_THICKNESS], true);
    }
}

BOX_INNER_WIDTH = BOX_FULL_WIDTH - 2 * BOX_SIDE_THICKNESS;
BOX_INNER_HEIGHT = BOX_FULL_HEIGHT - 2 * BOX_SIDE_THICKNESS;


SIDE_BRACKET_THICKNESS = BOX_SIDE_THICKNESS;
SIDE_BRACKET_LENGTH = 10;
SIDE_BRACKET_WIDTH = 20;
SIDE_BRACKET_HEIGHT = 20;

TEXT_PLATE_WIDTH = BOX_FULL_WIDTH - 10;
TEXT_PLATE_HEIGHT = 11;
TEXT_PLATE_THICKNESS = 2;

module side_bracket(w, d, h, t, hole_diam = 3)
{
    difference() {
        union () {
            cube([t, w, h]);
            cube([d + t, w, t]);
               
            /* Side prism */
            translate([d + t, 0, t]) rotate([0, 0, 90]) {
                prism(t, d, h - t);
          
                translate([w - t, 0, 0]) prism(t, d, h - t);
            }
        }
        translate([d / 4 * 3, w / 2, -0.2]) cylinder(d = hole_diam, h = t);
    }
}

EMERGENCY_X_OFFSET = - BOX_FULL_WIDTH/2 + EMERGENCY_BUTTON_DIAM/2 + BOX_SIDE_SPACING;
ABORT_X_OFFSET = - BOX_FULL_WIDTH/2 + EMERGENCY_BUTTON_DIAM + BOX_SIDE_SPACING +  BOX_BUTTON_SPACING + ABORT_BUTTON_DIAM/2;
HOLD_X_OFFSET = - BOX_FULL_WIDTH/2 + EMERGENCY_BUTTON_DIAM + BOX_SIDE_SPACING +  BOX_BUTTON_SPACING + ABORT_BUTTON_DIAM +  BOX_BUTTON_SPACING + HOLD_BUTTON_DIAM/2;
RESUME_X_OFFSET = - BOX_FULL_WIDTH/2 + EMERGENCY_BUTTON_DIAM + BOX_SIDE_SPACING +  BOX_BUTTON_SPACING + ABORT_BUTTON_DIAM +  BOX_BUTTON_SPACING + HOLD_BUTTON_DIAM +  BOX_BUTTON_SPACING + RESUME_BUTTON_DIAM/2;

FAN_SWITCH_X_OFFSET =  - BOX_FULL_WIDTH/2 + EMERGENCY_BUTTON_DIAM + BOX_SIDE_SPACING +  BOX_BUTTON_SPACING + ABORT_BUTTON_DIAM +  BOX_BUTTON_SPACING + HOLD_BUTTON_DIAM +  BOX_BUTTON_SPACING + RESUME_BUTTON_DIAM + BOX_SWITCH_SPACING  + FAN_SWITCH_WIDTH/2;

POWER_SWITCH_X_OFFSET =  - BOX_FULL_WIDTH/2 + EMERGENCY_BUTTON_DIAM + BOX_SIDE_SPACING +  BOX_BUTTON_SPACING + ABORT_BUTTON_DIAM +  BOX_BUTTON_SPACING + HOLD_BUTTON_DIAM +  BOX_BUTTON_SPACING + RESUME_BUTTON_DIAM +BOX_SWITCH_SPACING  + FAN_SWITCH_WIDTH + BOX_SWITCH_SPACING  + FAN_SWITCH_WIDTH/2;

TEXT_THICKNESS = 0.6;
TEXT_SIZE = 5;

module text_plate_line(line)
{
    text(text = line, font="gunplay", size = TEXT_SIZE, halign= "center", valign= "center");
}

module text_plate(delta)
{
    color("white")roundedcube([TEXT_PLATE_WIDTH + delta, TEXT_PLATE_HEIGHT + delta, TEXT_PLATE_THICKNESS], true, 1, "z");
    color("black") translate([0, 0, TEXT_PLATE_THICKNESS/2])  {
        /* Emergency text */
        translate([EMERGENCY_X_OFFSET, 0, ]) linear_extrude(height = TEXT_THICKNESS) text_plate_line("Emergency");
        /* Abort */
        translate([ABORT_X_OFFSET, 0, 0]) linear_extrude(height = TEXT_THICKNESS) text_plate_line("Abort");
        /* Hold */
        translate([HOLD_X_OFFSET, 0, 0]) linear_extrude(height = TEXT_THICKNESS) text_plate_line("Hold");
        /* Resume */
        translate([RESUME_X_OFFSET, 0, 0]) linear_extrude(height = TEXT_THICKNESS) text_plate_line("Resume");
        /* Switch */
        translate([FAN_SWITCH_X_OFFSET, 0, 0]) linear_extrude(height = TEXT_THICKNESS) text_plate_line("Misc");
        /* Power */
        translate([POWER_SWITCH_X_OFFSET, 0, 0]) linear_extrude(height = TEXT_THICKNESS) text_plate_line("Power");
    }
}


module button_box_enclosure() {
    difference() {
        button_box_block();
        translate([0, 0, -BOX_TOP_THICKNESS]) scale([BOX_INNER_WIDTH/BOX_FULL_WIDTH, BOX_INNER_HEIGHT/BOX_FULL_HEIGHT, 1]) button_box_block();

        translate([0, - BOX_FULL_HEIGHT/2 + EMERGENCY_BUTTON_DIAM/2 + BOX_BUTTON_BOTTOM_SPACING, BOX_THICKNESS/2 - BOX_PANEL_OFFSET/2]) { 
            /* Emergency button */
            translate([EMERGENCY_X_OFFSET, 0, 0]) rotate([BOX_PANEL_ANGLE, 0, 0]) cylinder(d = EMERGENCY_BUTTON_DIAM, h = BOX_THICKNESS, center = true);
            /* Abort button */
            translate([ABORT_X_OFFSET, 0, 0]) rotate([BOX_PANEL_ANGLE, 0, 0]) cylinder(d = ABORT_BUTTON_DIAM, h = BOX_THICKNESS, center = true);
            /* Hold button */
            translate([HOLD_X_OFFSET, 0, 0]) rotate([BOX_PANEL_ANGLE, 0, 0]) cylinder(d = HOLD_BUTTON_DIAM, h = BOX_THICKNESS, center = true);
            /* Resume button */
            translate([RESUME_X_OFFSET, 0, 0]) rotate([BOX_PANEL_ANGLE, 0, 0]) cylinder(d = RESUME_BUTTON_DIAM, h = BOX_THICKNESS, center = true);
            /* Power switch */
            translate([POWER_SWITCH_X_OFFSET, -10, 0]) rotate([BOX_PANEL_ANGLE, 0, 0]) cube([POWER_SWITCH_WIDTH, POWER_SWITCH_HEIGHT, BOX_THICKNESS], center = true);
            /* Power led */
            translate([POWER_SWITCH_X_OFFSET, 8, 0]) rotate([BOX_PANEL_ANGLE, 0, 0]) cylinder(d = LED_DIAMETER, h = BOX_THICKNESS, center = true);
            /* Misc switches */
            translate([FAN_SWITCH_X_OFFSET, -10, 0]) rotate([BOX_PANEL_ANGLE, 0, 0]) cube([POWER_SWITCH_WIDTH, POWER_SWITCH_HEIGHT, BOX_THICKNESS], center = true);
            translate([FAN_SWITCH_X_OFFSET, 8, 0]) rotate([BOX_PANEL_ANGLE, 0, 0]) cube([POWER_SWITCH_WIDTH, POWER_SWITCH_HEIGHT, BOX_THICKNESS], center = true);
            
        }    
        /* Cable holes */
        translate([-CABLE_HOLES_SPACING/2, 0, -BOX_THICKNESS/2 + CABLE_DIAMETER  + CABLE_BOTTOM_OFFSET]) rotate([-90, 0, 0]) cylinder(d = CABLE_DIAMETER , h = BOX_FULL_HEIGHT);
        translate([CABLE_HOLES_SPACING/2, 0, -BOX_THICKNESS/2 + CABLE_DIAMETER  + CABLE_BOTTOM_OFFSET]) rotate([-90, 0, 0]) cylinder(d = CABLE_DIAMETER , h = BOX_FULL_HEIGHT);

        /* Test plate button */
        translate([0, BOX_FULL_HEIGHT/2 - TEXT_PLATE_HEIGHT/2 - 4, BOX_THICKNESS/2 - BOX_PANEL_OFFSET/4]) rotate([BOX_PANEL_ANGLE, 0, 0])# text_plate(0.2);
    }
}

module button_box_enclosure_with_mount() {
    button_box_enclosure();
    translate([0, BOX_FULL_HEIGHT/2 - SIDE_BRACKET_THICKNESS, - BOX_THICKNESS/2]) {
        translate([SIDE_BRACKET_WIDTH/2 - BOX_FULL_WIDTH/5, 0, 0]) rotate ([0, 0, 90]) side_bracket(SIDE_BRACKET_WIDTH, SIDE_BRACKET_LENGTH, SIDE_BRACKET_HEIGHT, SIDE_BRACKET_THICKNESS);
        translate([SIDE_BRACKET_WIDTH/2 + BOX_FULL_WIDTH/5, 0, 0]) rotate ([0, 0, 90]) side_bracket(SIDE_BRACKET_WIDTH, SIDE_BRACKET_LENGTH, SIDE_BRACKET_HEIGHT, SIDE_BRACKET_THICKNESS);
    }
}

//text_plate(-0.2);

button_box_enclosure_with_mount();
