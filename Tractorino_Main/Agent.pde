class Agent {
    Wheels wheels;
    Axle axle;
    Machine machine;
    Cutter cutter;
    float cutterAngle;
    PVector pos;
    Field field;
    int loopCount;
    float dist;
    Controller controller;
    boolean placing;

    Agent() {
        this.placing = true;
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
        if (this.placing) {
            this.wheels.pos.x = mouseX;
            this.wheels.pos.y = mouseY;
        }
        this.wheels.show();
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

    void setDistance(float distance) {
        this.dist = distance;
    }

    void setStartingPosition(float x, float y) {
        this.placing = false;
        this.wheels.pos.x = x;
        this.wheels.pos.y = y;
        hud.panel.agentReady();
    }

    void setCutterAngle(float angle) {
        float cutterAngle = abs(abs(angle) - abs(this.wheels.heading));
        this.cutterAngle = cutterAngle;
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
}
