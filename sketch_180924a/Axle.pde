class Axle {
    float angle;
    PVector pos;

    Axle() {
        this.angle = 0;
        this.pos = new PVector(width/2, height/2);
    }

    void show() {
        pushMatrix();
        stroke(0,255,0);
        strokeWeight(1);
        translate(this.pos.x, this.pos.y);
        rotate(this.angle + PI/2);
        line(-5, -10, 5, -10);
        popMatrix();
    }

}
