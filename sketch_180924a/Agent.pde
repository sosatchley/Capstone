class Agent {
    Wheels wheels;
    Axle axle;
    Machine machine;
    Cutter cutter;

    Agent() {
        this.wheels = new Wheels();
        this.machine = new Machine(this.wheels.pos);
        this.axle = new Axle(this.machine, this.wheels);
        this.cutter = new Cutter(this.machine.pos);
        this.wheels.takeAgent(this);
    }

    void render() {
        this.wheels.show();
        this.axle.show();
        this.machine.show();
        this.cutter.show();
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
        }
    }

    void roll() {
        this.wheels.rolling = true;
    }

    void halt() {
        this.wheels.rolling = false;
    }

    float radians(int degrees) {
        float radians = degrees * PI / 180;
        return radians;
    }

    double degrees(float radians) {
        double degrees = radians * 180 / PI;
        return degrees;
    }



}
