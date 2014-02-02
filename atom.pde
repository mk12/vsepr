// Copyright 2014 Mitchell Kember. Subject to the MIT License.

class Atom {
  PVector pos;
  PVector vel;
  
  Atom() {
    this.pos = PVector.random3D();
    this.vel = new PVector(0, 0, 0);
  }
  
  void forces(Atom[] atoms) {
    for (Atom a : atoms) {
      if (a == null) break;
      if (a == this) continue;
      // Apply an inverse-square repulsion force.
      PVector accel = PVector.sub(a.pos, this.pos);
      accel.mult(-repulsion / pow(accel.mag(), 3));
      this.vel.add(accel);
    }
  }
  
  void update() {
    this.vel.mult(damping);
    this.pos.add(this.vel);
    // This effectively constrains the atom's movement
    // so that it can only rotate about the origin.
    this.pos.normalize();
  }
  
  void draw() {
    // Calculations take place within the unit circle.
    // The bondLength is only used for drawing.
    PVector p = PVector.mult(this.pos, bondLength);
    stroke(0);
    line(0, 0, 0, p.x, p.y, p.z);
    pushMatrix();
    translate(p.x, p.y, p.z);
    noStroke();
    fill(255);
    sphere(radiusX);
    popMatrix();
  }
}
