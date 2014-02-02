// Copyright 2014 Mitchell Kember. Subject to the MIT License.

// INSTRUCTIONS
// [up/down] change the number of bonded atoms
// [left/right] rotate the camera around the central atom
// [space] toggle displaying the bond angles
// I didn't bother adding keys to change the repulsion constant or
// damping ratio because nothing interesting happens. There are only
// three things worth trying (changing repulsion has almost no effect):
// damping = 1.00  never completely stabilizes
// damping = 0.50  stabilizes quickly
// damping = 0.01  stabilizes slowly

final float repulsion = 1.0; // repulsion force constant
final float damping = 0.5;   // vacuum = 1, viscous medium < 1

final int maxAtoms = 10;        // maximum value for N
final float radiusA = 50;       // radius of central atom 
final float radiusX = 20;       // radius of bonded atom
final float bondLength = 300;   // dist from central atom for bonded atom
final float textDistance = 100; // dist from central atom for angle text
final float zDistance = -200;   // camera Z distance from origin
final float sensitivity = 0.02; // left/right arrow key rotation speed

int N = 0; // number of bonded atoms
float rot = 0; // current y-rotation
boolean showAngles = false;
Atom[] atoms = new Atom[maxAtoms];

void setup() {
  size(600, 600, P3D);
  textSize(18);
  textAlign(CENTER, CENTER);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP && N != maxAtoms) {
      atoms[N++] = new Atom();
    } else if (keyCode == DOWN && N != 0) {
      atoms[--N] = null;
    }
  } else if (key == 32) { // space bar
    showAngles = !showAngles;
  }
}

void draw() {
  transform();
  background(200);
  lights();
  noStroke();
  // Draw central atom.
  fill(230, 100, 70);
  sphere(radiusA);
  // Update and draw bonded atoms and angles.
  for (int i = 0; i < N; i++) {
    atoms[i].forces(atoms);
    atoms[i].update();
    atoms[i].draw();
    if (showAngles) {
      for (int j = i+1; j < N; j++) {
        showAngle(i, j);
      }
    }
  }
}

// Check some keyboard input and apply transformations.
void transform() {
  // Handle left/right here, called by draw(), rather than
  // in keyPressed() because we want continuous rotation.
  if (keyPressed && key == CODED) {
    if (keyCode == LEFT) {
      rot += sensitivity;
    } else if (keyCode == RIGHT) {
      rot -= sensitivity;
    }
  }
  translate(width/2, height/2, zDistance);
  rotateY(rot);
}

// Draw the bond angle between atoms[i] and atoms[j].
void showAngle(int i, int j) {
  PVector p1 = atoms[i].pos;
  PVector p2 = atoms[j].pos;
  float angle = degrees(PVector.angleBetween(p1, p2));
  String str = String.format("%.1fº", angle);
  // Go between the two bond lines.
  PVector bisector = PVector.add(p1, p2);
  bisector.mult(textDistance / bisector.mag());
  pushMatrix();
  // Translate, THEN rotate so that text moves out in the proper
  // direction before being turned to face the screen.
  translate(bisector.x, bisector.y, bisector.z);
  rotateY(-rot);
  fill(0);
  text(str, 0, 0, 0);
  popMatrix();
}
