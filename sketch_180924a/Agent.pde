class Agent {
    Wheels wheels;
    Axle axle;
    Machine machine;
    Cutter cutter;

    Agent() {
        wheels = new Wheels();
        axle = new Axle();
        machine = new Machine();
        cutter = new Cutter();
    }

    void render() {
        this.wheels.show();
        this.axle.show();
        this.machine.show();
        this.cutter.show();
    }

    void turn(int dir) {
        if (dir == 1) {

            if ((this.wheels.angle - this.machine.angle) < (degrees(60))) {
                this.wheels.turn(0.1);
            }
        } else if (dir == 0) {
            if ((this.wheels.angle - this.machine.angle) > (degrees(-60))) {
                this.wheels.turn(-0.1);
            }
        }
    }

    void roll() {
        System.out.println("called roll");
        this.wheels.rolling = true;
    }

    void stop() {
        this.wheels.rolling = false;
    }

    float degrees(int degrees) {
        float radians = degrees * PI / 180;
        return radians;
    }

}
