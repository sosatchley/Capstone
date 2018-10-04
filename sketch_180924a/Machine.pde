class Machine {
      PVector pos;
      PVector follow;
      float angle;

    Machine(PVector wheelPos) {
        this.pos = new PVector(wheelPos.x-20, wheelPos.y);
        this.follow = wheelPos;
        this.angle = 0;
    }


    void show() {
        changeAngle();
        changePos();
        pushMatrix();
        noFill();
        stroke(0,255,0);
        strokeWeight(1);
        translate(this.pos.x, this.pos.y);
        rotate(this.angle);
        triangle(0, -10, 0, 10, 20, 0);

        popMatrix();
    }

    void changeAngle() {
        float dx = this.follow.x - this.pos.x;
        float dy = this.follow.y - this.pos.y;
        float angle = atan2(dy, dx);
        this.angle = angle;
    }

    void changePos() {
        this.pos.x = this.follow.x - cos(this.angle) * 20;
        this.pos.y = this.follow.y - sin(this.angle) * 20;
    }

    float getAngle() {
        return this.angle;
    }
}
