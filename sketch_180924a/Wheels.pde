class Wheels {
    float angle;
    PVector pos;
    PVector vel;
    Boolean rolling;

    Wheels() {
        this.angle = 0;
        this.pos = new PVector(width/2, height/2);
        this.vel = new PVector(0, 0);
        this.rolling = false;
    }

    void show() {
        pushMatrix();
        stroke(0,0,255);
        strokeWeight(3);
        translate(this.pos.x, this.pos.y);
        rotate(PI/2);
        showLeft();
        showRight();
        popMatrix();
        if (rolling) {
            System.out.println(rolling);
            roll();
        }
    }

    void showLeft() {
        pushMatrix();
        translate(-5, -10);
        rotate(this.angle);
        line(0, -3, 0, 3);
        popMatrix();
    }

    void showRight() {
        pushMatrix();
        translate(5, -10);
        rotate(this.angle);
        line(0, -3, 0, 3);
        popMatrix();
    }

    void turn(float a) {
        this.angle += a;
    }

    void roll() {
        PVector p = PVector.fromAngle(this.angle);
        this.vel.add(p);
    }

}
