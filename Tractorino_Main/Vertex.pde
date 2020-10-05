class Vertex {
    float x;
    float y;
    float angle;
    Vertex neighbor;
    Agent agent;
    int side;
    int moves;
    boolean deprecated;
    // color c;

    Vertex(Agent agent, float x, float y, float angle, int side) {
        this.agent = agent;
        this.x = x;
        this.y = y;
        this.angle = angle;
        this.side = side;
        this.moves = 0;
        this.deprecated = false;
    }

    Vertex(Agent agent, PVector pos, float angle, int side) {
        this.agent = agent;
        this.x = pos.x;
        this.y = pos.y;
        this.angle = angle;
        this.side = side;
        this.moves = 0;
        this.deprecated = false;
    }

    Vertex(Agent agent, PVector pos, float angle, Vertex neighbor, int side) {
        this.agent = agent;
        this.x = pos.x;
        this.y = pos.y;
        this.angle = angle;
        this.neighbor = neighbor;
        this.side = side;
        this.moves = 0;
        this.deprecated = false;
    }

    Vertex(Vertex oldVertex, PVector pos, float angle, Vertex neighbor) {
        this.agent = oldVertex.agent;
        this.x = pos.x;
        this.y = pos.y;
        this.angle = angle;
        this.neighbor = neighbor;

    }


    Vertex(Agent agent, float x, float y, float angle, Vertex neighborint, int side) {
        this.agent = agent;
        this.x = x;
        this.y = y;
        this.angle = angle;
        this.neighbor = neighbor;
        this.side = side;
        this.moves = 0;
        this.deprecated = false;
        // this.c = getColor();
    }

    void render() {
        stroke(getColor());
        strokeWeight(2);

        if (this.deprecated) {
            noStroke();
        }
        if (passed(this.agent.cutter)) {
            move(this.agent.cutter);
        }
        point(x, y);
    }

    color getColor() {
        if (this.neighbor == null) {
            return color(0, 136, 255);
        }
        // FIXME: Make these values less arbitrary, so they can be reactive to changes in vertex interval
        float diff = calcSlope();
        if (abs(diff) < .002) {
            return color(0, 255, 0);
        } else if (abs(diff) < .006) {
            return color(219, 255, 0);
        } else if (abs(diff) < .01) {
            return color(255, 153, 0);
        } else if (abs(diff) < .1) {
            return color(255, 0, 0);
        } else {
            return color(0, 136, 255);
        }
    }

    float calcSlope() {
        return abs(this.angle - this.neighbor.angle);
    }

    void move(Cutter cutter) {
        this.agent.setLastVert(this);
        PVector p = angularDisplacement(x, y, 9+passBy(cutter), this.angle, -this.side);
        this.x = p.x;
        this.y = p.y;
        this.angle = cutter.angle;
        this.moves++;
    }

    boolean passed(Cutter cutter) {
        // FIXME: Passed Vertex function. This is just the worst.
        // pushMatrix();
        // PVector p = angularDisplacement(this.x, this.y, 10, this.angle, -this.side);
        // float angle = degrees(this.angle);
        // int mult = (angle < 0 || angle > 90) ? -1 : 1;
        // float rot;
        // if (abs(angle) > 90) {
        //     rot = (angle % 90) * mult;
        // } else {
        //     rot = 90 - abs(angle) * mult;
        // }
        // rotate(rot);
        // if (abs(degrees(this.angle)) > 90) {
            if (passBy(cutter) < 9) {
                // popMatrix();
                return true;
            }
            // popMatrix();
            return false;
        // } else if (abs(degrees(this.angle)) < 90) {
        //     if ((this.x == cutter.pos.x) && (passBy(cutter) < 20)) {
        //         popMatrix();
        //         return true;
        //     }
        //     popMatrix();
        //     return false;
        // }
        // popMatrix();
        // return false;
    }

    float passBy(Cutter cutter) {
        return dist(cutter.pos.x, cutter.pos.y, this.x, this.y);
    }
}
