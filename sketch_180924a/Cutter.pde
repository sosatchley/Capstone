class Cutter {
    float angle;
    PVector pos;

    Cutter() {
        this.angle = 0;
        this.pos = new PVector(width/2, height/2);
    }

    void show() {
        pushMatrix();
        stroke(0,255,0);
        strokeWeight(1);
        translate(this.pos.x, this.pos.y);
        rotate(this.angle + PI/2);
        line(0,10,0,15);
        ellipse(0,24,18,18);
        popMatrix();
    }



}
