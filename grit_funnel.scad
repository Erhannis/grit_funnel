/**
Run get_deps.sh to clone dependencies into a linked folder in your home directory.
*/

use <deps.link/BOSL/nema_steppers.scad>
use <deps.link/BOSL/joiners.scad>
use <deps.link/BOSL/shapes.scad>
use <deps.link/erhannisScad/misc.scad>
use <deps.link/erhannisScad/auto_lid.scad>
use <deps.link/scadFluidics/common.scad>
use <deps.link/quickfitPlate/blank_plate.scad>
use <deps.link/getriebe/Getriebe.scad>
use <deps.link/gearbox/gearbox.scad>

$FOREVER = 1000;
DUMMY = false;
$fn = DUMMY ? 10 : 60;

IS_RESERVOIR = true;
IS_RESERVOIR_GATE = false;

TUBE_OD = 25.4*(3/8);
TUBE_ID = IS_RESERVOIR ? TUBE_OD : 25.4*(1/4);
WALL = 2;
HEIGHT = IS_RESERVOIR ? 90 : 70;
SPOUT_OD = TUBE_OD+2*WALL;
SPOUT_H = TUBE_OD+WALL;

if (!IS_RESERVOIR_GATE) { // Enums would be nice
  // Funnel
  difference() {
    // Funnel solid
    rotate_extrude() {
      intersection() {
        triangle(height=HEIGHT);
        QXp();
      }
    }
    // Funnel subtraction
    rotate_extrude() {
      intersection() {
        triangle(height=HEIGHT-(sqrt(2)*WALL));
        QXp();
      }
    }
    // Lop off tip, for spout
    tz(HEIGHT-SPOUT_OD/2) OZp();
  }

  // Spout
  tz(HEIGHT-SPOUT_OD/2) difference() {
    cylinder(d=SPOUT_OD, h=SPOUT_H);
    tz(WALL) cylinder(d=TUBE_OD, h=SPOUT_H);
    cylinder(d=TUBE_ID, h=SPOUT_H);
  }

  // Handle
  union() {
    difference() {
      tx(HEIGHT) ty(-SPOUT_OD/2) cube([WALL, SPOUT_OD, HEIGHT-SPOUT_OD/2+SPOUT_H]);
      ctranslate([[0,0,10],[0,0,HEIGHT-10]]) ry(90) cylinder(d=2, h=$FOREVER);
    }
    difference() {
      tx(HEIGHT) ty(-SPOUT_OD/2) mx() tz(HEIGHT-SPOUT_OD/2+SPOUT_H-WALL) cube([HEIGHT, SPOUT_OD, WALL]);
      tz(WALL) cylinder(d=TUBE_OD, h=$FOREVER);
    }
    tx(HEIGHT) ty(-SPOUT_OD/2) mx() cube([1.5*WALL,SPOUT_OD,WALL]);
    if (IS_RESERVOIR) {
      // Handle brace
      difference() {
        union() {
          tx(HEIGHT) ty(-(HEIGHT-SPOUT_OD/2+SPOUT_H)/2) cube([WALL, HEIGHT-SPOUT_OD/2+SPOUT_H, SPOUT_OD]);
          tx(HEIGHT) ty(-(HEIGHT-SPOUT_OD/2+SPOUT_H)/2) ry(-90) cube([WALL, HEIGHT-SPOUT_OD/2+SPOUT_H, SPOUT_OD]);
        }
        // Funnel subtraction
        rotate_extrude() {
          intersection() {
            triangle(height=HEIGHT-(sqrt(2)*WALL));
            QXp();
          }
        }        
        // Mounting holes
        ctranslate([
          [0,0,10],
          [0,0,HEIGHT-10],
          [0,(HEIGHT-SPOUT_OD/2+SPOUT_H)/2-SPOUT_OD/2,SPOUT_OD/2],
          [0,-((HEIGHT-SPOUT_OD/2+SPOUT_H)/2-SPOUT_OD/2),SPOUT_OD/2],
        ]) ry(90) cylinder(d=2, h=$FOREVER);
      }
    }
  }
}

if (IS_RESERVOIR_GATE) color("red") {
  cmirror([0,1,0]) tz(HEIGHT-SPOUT_OD/2+SPOUT_H) {
    difference() {
      ty(-SPOUT_OD/2) cube([50,SPOUT_OD,WALL]);
      tx(50-SPOUT_OD) cylinder(d=SPOUT_OD, h=$FOREVER, center=true);
    }
    cylinder(d=SPOUT_OD,h=WALL);
    tz(-WALL*2) tx(SPOUT_OD/2) ty(SPOUT_OD/2) cube([50-SPOUT_OD/2,WALL,WALL*3]);
    tz(-WALL) ty(SPOUT_OD/2) tx(SPOUT_OD/2) rx(-135) cube([50-SPOUT_OD/2,WALL,WALL]);
    tz(-WALL*2-WALL*3) tx(SPOUT_OD/2+40-SPOUT_OD/2) ty(SPOUT_OD/2) cube([10,WALL,WALL*6]);
  }
}
