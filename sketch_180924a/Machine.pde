class Machine {
      PVector pos;
      float angle;

    Machine() {
        this.pos = new PVector(width/2, height/2);
        this.angle = 0;
    }

    void show() {
        pushMatrix();
        noFill();
        stroke(0,255,0);
        strokeWeight(1);
        translate(this.pos.x, this.pos.y);
        rotate(this.angle + PI/2);
        triangle(-10, 10, 10, 10, 0, -10);
        popMatrix();
    }
}
