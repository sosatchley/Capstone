class Agent {
    Wheels wheels;
    Axle axle;
    Machine machine;
    Cutter cutter;
    float cutterAngle;
    PVector pos;
    Field field;
    int loopCount;
    Vertex lastVertex;
    Vertex closestVertex;
    float dist;
    Controller controller;

    Agent() {
        this.controller = new Controller(this);
        this.wheels = new Wheels();
        this.machine = new Machine(this.wheels.pos);
        this.axle = new Axle(this.machine, this.wheels);
        this.cutter = new Cutter(this.machine.pos);
        this.wheels.takeAgent(this);
        this.pos = this.machine.pos;
        this.loopCount = 0;

    }

    void render() {
        this.wheels.show();
        if (this.field != null) {
            setClosestVert();
        }
        this.axle.show();
        this.machine.show();
        this.cutter.show();
        setCutterAngle(this.cutter.angle);
    }

    void turn(int dir) {
        if (dir == 1) {
            if (degrees(this.wheels.steeringAngle) < 60) {
                this.wheels.turn(0.1);
            }
        } else if (dir == 0) {
            if (degrees(this.wheels.steeringAngle) > -60) {
                this.wheels.turn(-0.1);
            }
        } else {
        }
    }

    void roll() {
        this.wheels.rolling = true;
    }

    void halt() {
        this.wheels.rolling = false;
    }

    void loopCheck() { // Removes verticies 2 loops or more behind most recent vertex
        int moves;
        if (this.lastVertex == null) {
            moves = 0;
        } else {
            moves = this.lastVertex.moves;
        }
        if (moves > this.loopCount) {
            this.loopCount = moves;
            this.field.vertCheck(this.loopCount);
        }
    }

    void setLastVert(Vertex vert) {
        this.lastVertex = vert;
    }

    void setClosestVert() {
        this.closestVertex = this.wheels.findClosest();
    }

    void setDistance(float distance) {
        this.dist = distance;
    }

    void setCutterAngle(float angle) {
        float cutterAngle = abs(abs(angle) - abs(this.wheels.heading));
        this.cutterAngle = cutterAngle;
    }

    float radians(int degrees) {
        float radians = degrees * PI / 180;
        return radians;
    }

    double degrees(float radians) {
        double degrees = radians * 180 / PI;
        return degrees;
    }

    Wheels getWheels() {
        return this.wheels;
    }

    float getHeading() {
        return this.wheels.heading;
    }

    public Axle getAxle() {
        return this.axle;
    }

    Machine getMachine() {
        return this.machine;
    }

    Cutter getCutter() {
        return this.cutter;
    }

    void field(Field field) {
        this.field = field;
    }

    void getAngle() {
        PVector[] closest = new PVector[50];
        for (int i = 0; i < field.shape.getVertexCount()-1; i++) {
            PVector vertex = field.shape.getVertex(i);
            if (i < 50) {
                closest[i] = vertex;
            } else {
                for (int j = 0; j < 50; j++) {
                    // println(distance(this.pos, vertex));
                    // println(distance(this.pos, closest[j]));
                    // println(distance(this.pos, vertex));
                    // println(dist(this.pos.x, this.pos.y, vertex.x, vertex.y));
                    // if (distance(this.pos, vertex) < distance(this.pos, closest[j])) {
                    if (dist(this.pos.x, this.pos.y, vertex.x, vertex.y) < dist(this.pos.x, this.pos.y, closest[j].x, closest[j].y)) {
                        closest[j] = vertex;
                    }
                }
            }
        }
        double dist = 0;
        PVector p = new PVector();
        PVector q = new PVector();
        for (int i = 0; i < 50; i++) {
            double thisDist;
            for(int j = 0; j < 50; j++) {
                thisDist = distance(closest[i], closest[j]);
                if (dist == 0) {
                    dist = thisDist;
                } else if (dist < thisDist) {
                    dist = thisDist;
                    p = closest[i];
                    q = closest[j];
                    // println("P: " + coord(p));
                    // println("Q: " + coord(q));
                }
            }
        }
        strokeWeight(15);
        stroke(255,0,0);
        point(p.x, p.y);
        point(q.x, q.y);
        // float angle = atan2(p,q);
        // return angle;
    }
}
