class Wheels {
    float steeringAngle;
    float drawAngle;
    float heading;
    float speedMult;
    PVector pos;
    PVector vel;
    Agent agent;
    Boolean rolling;
    ArrayList<Vertex> verts;

// Constructs Wheel Object
    Wheels() {
        this.steeringAngle = 0;
        this.drawAngle = 0;
        this.heading = 0;
        this.pos = new PVector(width/2, height/2);
        this.vel = new PVector(0, 0);
        this.rolling = false;
        this.speedMult = .5;
    }

// Renders Wheel object on canvas
    void show() {
        pushMatrix();
        translate(this.pos.x, this.pos.y);
        this.heading = this.agent.machine.angle;
        rotate(heading + PI/2);
        // if (this.verts != null) {
        //     findClosest();
        // }
        maintain();
        stroke(255,0,0);
        strokeWeight(3);
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

    void setVerts(ArrayList<Vertex> verts) {
        this.verts = verts;
    }

    Vertex findClosest() {
        float thisDist;
        float dist = 0;
        Vertex closest = null;
        for (Vertex vert : this.verts) {
            thisDist = dist(this.pos.x, this.pos.y, vert.x, vert.y);
            if (thisDist < dist || dist == 0) {
                if (abs(degrees(atan2(vert.y, vert.x))) < 90) {
                    closest = vert;
                    dist = thisDist;
                }
            }
            strokeWeight(10);
            stroke(255);
        }
        this.agent.setDistance(dist);
        return closest;
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
        this.vel = p.mult(this.speedMult);
        this.pos.add(this.vel);
    }

// Used to get machine heading
    void takeAgent(Agent agent) {
        this.agent = agent;
    }

}
