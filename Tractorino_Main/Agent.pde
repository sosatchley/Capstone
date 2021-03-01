class Agent {
    Wheels wheels;
    Machine machine;
    Cutter cutter;

    float scale;
    Controller controller;
    boolean placing;

    Agent() {
        this.placing = false;
        this.scale = 1;
    }

    Agent(CutterMaker tool) {
        this.scale = 1;
        this.wheels = new Wheels();
        this.machine = new Machine();
        this.placing = true;
        this.setCutter(tool);
    }

    void render() {
        if (this.placing) {
            this.wheels.pos.x = mouseX;
            this.wheels.pos.y = mouseY;
        }
        this.wheels.show();
        this.machine.show();
        this.cutter.show();
    }

    void setWheels(PVector pos, float angle) {
        this.wheels = new Wheels(pos, angle);
    }

    void setMachine(PVector pos, float angle) {
        this.machine = new Machine(pos, angle);
    }

    void setCutter(CutterMaker tool) {
        tool.setEnclosingInstance(this);
        Cutter cutter = tool.createCutter();
        this.cutter = cutter;
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

    void setStartingPosition(float x, float y) {
        this.placing = false;
        this.wheels.pos.x = x;
        this.wheels.pos.y = y;
        hud.panel.agentReady();
    }

    Wheels getWheels() {
        return this.wheels;
    }

    float getHeading() {
        return this.wheels.heading;
    }

    Machine getMachine() {
        return this.machine;
    }

    Cutter getCutter() {
        return this.cutter;
    }

    class Wheels {
        float steeringAngle;
        float heading;
        float speedMult;
        PVector pos;
        PVector vel;
        Boolean rolling;

        final float wheelSize = 3;
        final float wheelWidth = 5;

        Wheels() {
            this.steeringAngle = 0;
            this.heading = 0;
            this.pos = new PVector(0, 0);
            this.vel = new PVector(0, 0);
            this.rolling = false;
            this.speedMult = .5;
        }

        Wheels(PVector pos, float heading) {
            this.steeringAngle = 0;
            this.heading = heading;
            this.pos = pos;
            this.vel = new PVector(0, 0);
            this.rolling = false;
            this.speedMult = .5;
        }

        void show() {
            this.heading = Agent.this.machine.angle;
            pushMatrix();
            translate(this.pos.x, this.pos.y);
            rotate(heading + PI/2);
            stroke(255,0,0);
            strokeWeight(2*scale);
            showLeft();
            showRight();
            popMatrix();
            if (rolling) {
                roll();
            }
            this.speedMult = Agent.this.scale;
        }

        void showLeft() {
            float scale = Agent.this.scale;
            pushMatrix();
            translate(-this.wheelWidth * scale, 0);
            rotate(this.steeringAngle);
            line(0, -this.wheelSize * scale, 0, this.wheelSize * scale);
            popMatrix();
        }

        void showRight() {
            float scale = Agent.this.scale;
            pushMatrix();
            translate(this.wheelWidth * scale, 0);
            rotate(this.steeringAngle);
            line(0, -this.wheelSize * scale, 0, this.wheelSize * scale);
            popMatrix();
        }

        void turn(float a) {
            this.steeringAngle += a;
        }

        void roll() {
            PVector p = PVector.fromAngle(this.steeringAngle+this.heading);
            this.vel = p.mult(this.speedMult);
            this.pos.add(this.vel);
        }

        PVector getPosition() {
            return this.pos;
        }

        float getAngle() {
            return this.heading;
        }
    }

    class Machine {
          PVector pos;
          float angle;

          final float frontWidth = 5;
          final float rearWidth = 10;
          final float wheelbase = 25;
          final float wheelSize = 10;

        Machine() {
            this.pos = new PVector(Agent.this.wheels.pos.x-(wheelbase*Agent.this.scale), Agent.this.wheels.pos.y);
            this.angle = 0;
        }

        Machine(PVector pos, float heading) {
            this.pos = pos;
            this.angle = heading;
        }

        void show() {
            float scale = Agent.this.scale;
            changeAngle();
            changePos();
            pushMatrix();
            noFill();
            stroke(0,255,0);
            strokeWeight(1*scale);
            translate(this.pos.x, this.pos.y);
            rotate(this.angle);
            triangle(0, -rearWidth*scale, 0, rearWidth*scale, wheelbase*scale, 0); //Body
            line(wheelbase*scale, -frontWidth*scale, wheelbase*scale, frontWidth*scale); //Front Axle
            stroke(255,0,0);
            strokeWeight(3*scale);
            line(0, -rearWidth*scale, wheelSize*scale, -rearWidth*scale); //Rear Left Wheel
            line(0, rearWidth*scale, wheelSize*scale, rearWidth*scale); //Rear Right Wheel
            popMatrix();
        }

        void changeAngle() {
            float dx = Agent.this.wheels.pos.x - this.pos.x;
            float dy = Agent.this.wheels.pos.y - this.pos.y;
            float angle = atan2(dy, dx);
            // println(angle);
            // exit();
            this.angle = angle;
        }

        void changePos() {
            this.pos.x = Agent.this.wheels.pos.x - cos(this.angle) * (wheelbase*scale);
            this.pos.y = Agent.this.wheels.pos.y - sin(this.angle) * (wheelbase*scale);
        }

        PVector getPosition() {
            return this.pos;
        }

        float getAngle() {
            return this.angle;
        }
    }

    abstract class Cutter {
        CutterMaker cutterType;
        float angle;
        PVector pos;
        float hitchSize;
        float cutSwath;
        float cutterDepth;
        float fullLength;

        // Cutter() {
        //     this.angle = 0;
        //     this.pos = new PVector(Agent.this.machine.pos.x-19, Agent.this.machine.pos.y);
        // }

        abstract void show();

        abstract void changeAngle();

        void changePos() {
            float scale = Agent.this.scale;
            this.pos.x = Agent.this.machine.pos.x - cos(this.angle) * (this.fullLength * scale);
            this.pos.y = Agent.this.machine.pos.y - sin(this.angle) * (this.fullLength * scale);
        }

        void setPosition(PVector pos) {
            this.pos = pos;
        }

        void setAngle(float angle) {
            this.angle = angle;
        }

        PVector getPosition() {
            return this.pos;
        }

        float getAngle() {
            return this.angle;
        }

        String getType() {
            return this.cutterType.toString();
        }
    }

    class RotaryCutter extends Cutter {
        RotaryCutter() {
            this.cutterType = CutterMaker.ROTARYCUTTER;
            this.hitchSize = 10;
            this.cutSwath = 22;
            this.cutterDepth = 26;
            this.fullLength = this.hitchSize + this.cutterDepth;
            this.angle = 0;
            this.pos = new PVector(Agent.this.machine.pos.x-(fullLength*Agent.this.scale), Agent.this.machine.pos.y);
        }

        void show() {
            float scale = Agent.this.scale;
            changeAngle();
            changePos();
            pushMatrix();
            stroke(0,255,0);
            strokeWeight(1*scale);
            point(0,0);
            translate(this.pos.x, this.pos.y);
            rotate(this.angle - PI/2);
            showCutterBody();
            line(0,(cutterDepth*scale), 0, (fullLength*scale));
            stroke(255,0,0);
            line((-cutSwath*scale)/4, 0, (-cutSwath*scale)/4, (cutterDepth*scale)*.33);
            line((cutSwath*scale)/4, 0, (cutSwath*scale)/4, (cutterDepth*scale)*.33);
            popMatrix();
        }

        void showCutterBody() {
            PShape s = createShape();
            s.beginShape();
            s.vertex((-cutSwath*scale)*0.375, (cutterDepth*scale)*.33);
            s.vertex((-cutSwath*scale)*0.5, (cutterDepth*scale)*.5);
            s.vertex((-cutSwath*scale)*0.5, (cutterDepth*scale));
            s.vertex((cutSwath*scale)*0.5, (cutterDepth*scale));
            s.vertex((cutSwath*scale)*0.5, (cutterDepth*scale)*.5);
            s.vertex((cutSwath*scale)*0.375, (cutterDepth*scale)*.33);
            s.endShape(CLOSE);
            shape(s, 0, 0);
        }

        void changeAngle() {
            float dx = Agent.this.machine.pos.x - this.pos.x;
            float dy = Agent.this.machine.pos.y - this.pos.y;
            float angle = atan2(dy, dx);
            this.angle = angle;
        }

        void changePos() {
            float scale = Agent.this.scale;
            this.pos.x = Agent.this.machine.pos.x - cos(this.angle) * (fullLength*Agent.this.scale);
            this.pos.y = Agent.this.machine.pos.y - sin(this.angle) * (fullLength*Agent.this.scale);
        }
    }

    class DiscMower extends Cutter {
        DiscMower() {
            this.cutterType = CutterMaker.DISCMOWER;
            this.hitchSize = 10;
            this.cutSwath = 22;
            this.cutterDepth = 10;
            this.fullLength = this.hitchSize*.5 + this.cutterDepth;
            this.angle = 0;
            this.pos = new PVector(Agent.this.machine.pos.x, Agent.this.machine.pos.y);
        }

        void show() {
            float scale = Agent.this.scale;
            changeAngle();
            changePos();
            pushMatrix();
            stroke(0,255,0);
            strokeWeight(1*scale);
            translate(this.pos.x, this.pos.y);
            rotate(this.angle);
            line(-hitchSize*scale,0,0,0);
            line(-hitchSize*scale,0,-hitchSize*scale,hitchSize*scale);
            rect(-fullLength*scale,hitchSize*scale,cutterDepth*scale,cutSwath*scale);
            stroke(255, 0, 0);
            popMatrix();
        }

        void changeAngle() {
            this.angle = Agent.this.machine.angle;
        }

        void changePos() {
            this.pos.x = Agent.this.machine.pos.x;
            this.pos.y = Agent.this.machine.pos.y;
        }
    }
}
