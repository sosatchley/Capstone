class Wheels {
    float steeringAngle;
    float drawAngle;
    float heading;
    PVector pos;
    PVector vel;
    Agent agent;
    Boolean rolling;

// Constructs Wheel Object
    Wheels() {
        this.steeringAngle = 0;
        this.drawAngle = 0;
        this.heading = 0;
        this.pos = new PVector(width/2, height/2);
        this.vel = new PVector(0, 0);
        this.rolling = false;
    }

// Renders Wheel object on canvas
    void show() {
        pushMatrix();
        stroke(255,0,0);
        strokeWeight(3);
        translate(this.pos.x, this.pos.y);
        this.heading = this.agent.machine.angle;
        rotate(heading + PI/2);
        maintain();
        showLeft();
        showRight();
        popMatrix();
        if (rolling) {
            roll();
        }
    }

    void showLeft() {
        pushMatrix();
        translate(-5, 0);
        rotate(this.drawAngle);
        line(0, -3, 0, 3);
        popMatrix();
    }

    void showRight() {
        pushMatrix();
        translate(5, 0);
        rotate(this.drawAngle);
        line(0, -3, 0, 3);
        popMatrix();
    }

    void maintain() {
        this.drawAngle = this.steeringAngle + this.heading;
        this.drawAngle -= this.heading;
    }

    void turn(float a) {
        this.steeringAngle += a;
    }


    void roll() {
        PVector p = PVector.fromAngle(this.steeringAngle+this.heading);
        this.vel = p.div(2);
        this.pos.add(this.vel);
    }

// Used to get machine heading
    void takeAgent(Agent agent) {
        this.agent = agent;
    }

}
