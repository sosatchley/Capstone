import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_180924a extends PApplet {

// Shane Atchley
// CSCI 410
// Auto-Steer Simulation

Agent agent;
HUD hud;

public void setup() {
  
  agent = new Agent();
  hud = new HUD(this);
  // frameRate(10);
}

public void draw() {
  background(0);
  agent.render();
  hud.render();
  mouseListener();
}

public void mouseListener() {
    if (mouseY > 900) {
        hud.show();
    }
    else if (mouseY < 800) {
        hud.hide();
    }
}

public void keyPressed() {
    if (keyCode == RIGHT) {
        agent.turn(1);
    } else if (keyCode == LEFT) {
        agent.turn(0);
    } else if (keyCode == UP) {
        agent.roll();
    } else if (keyCode == DOWN) {
        agent.halt();
    }
}

public void keyReleased() {
    //Record wheel to machine heading ratio at end of turn, turn wheels after release to maintain ratio
}
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

    public void render() {
        this.wheels.show();
        this.axle.show();
        this.machine.show();
        this.cutter.show();
    }

    public void turn(int dir) {
        if (dir == 1) {
            if (degrees(this.wheels.steeringAngle) < 60) {
                this.wheels.turn(0.1f);
            }
        } else if (dir == 0) {
            if (degrees(this.wheels.steeringAngle) > -60) {
                this.wheels.turn(-0.1f);
            }
        }
    }

    public void roll() {
        this.wheels.rolling = true;
    }

    public void halt() {
        this.wheels.rolling = false;
    }

    public float radians(int degrees) {
        float radians = degrees * PI / 180;
        return radians;
    }

    public double degrees(float radians) {
        double degrees = radians * 180 / PI;
        return degrees;
    }



}
class Axle {
    float angle;
    PVector pos;
    PVector follow;
    Machine machine;

    Axle(Machine machine, Wheels wheels) {
        this.angle = 0;
        this.pos = wheels.pos;
        this.follow = machine.pos;
        this.angle = machine.angle+PI/2;
        this.machine = machine;
    }

    public void show() {
        changeAngle();
        // changePos();
        pushMatrix();
        stroke(0,255,0);
        strokeWeight(1);
        translate(this.pos.x, this.pos.y);
        rotate(this.angle);
        line(-5, 0, 5, 0);
        popMatrix();
    }

    public void changeAngle() {
        this.angle = machine.getAngle() + PI/2;
    }

    public void changePos() {
        this.pos.x = this.follow.x+20 - cos(this.angle *20);
        this.pos.y = this.follow.y - sin(this.angle *20);
    }

}
class Cutter {
    float angle;
    PVector pos;
    PVector follow;

    Cutter(PVector machinePos) {
        this.angle = 0;
        this.pos = new PVector(machinePos.x-19, machinePos.y);
        this.follow = machinePos;
    }

    public void show() {
        changeAngle();
        changePos();
        pushMatrix();
        stroke(0,255,0);
        strokeWeight(1);
        translate(this.pos.x, this.pos.y);
        rotate(this.angle);
        line(9,0,16,0);
        ellipse(0,0,18,18);
        popMatrix();
    }

    public void changeAngle() {
        float dx = this.follow.x - this.pos.x;
        float dy = this.follow.y - this.pos.y;
        float angle = atan2(dy, dx);
        this.angle = angle;
    }

    public void changePos() {
        this.pos.x = this.follow.x - cos(this.angle) * 16;
        this.pos.y = this.follow.y - sin(this.angle) * 16;
    }
}
class Field {
    Boolean complete;
    PShape shape;


    Field() {

    }

    public void beginCircuit() {

    }
}

class HUD {
    PApplet sketch;
    float curHeight;
    int showHeight;
    int hideHeight;
    boolean vis;
    ControlP5 control;
    Textlabel viewLabel;
    Textlabel algLabel;
    PFont font;
    Toggle predictToggle;
    Toggle pathToggle;
    Toggle followToggle;
    Button fieldStarter;
    Slider testSlider;

    HUD(PApplet sketch) {

        this.sketch = sketch;
        this.showHeight = 200;
        this.curHeight = height;
        this.vis = false;
        this.font = createFont("OpenSansCondensed-Light.ttf", 32);

        control = new ControlP5(sketch);
        // Labels
        viewLabel = new Textlabel(control, "View", 100, 10, 150,150);
        algLabel = new Textlabel(control, "Info", 800, 10, 150,150);
        viewLabel.setFont(this.font);
        algLabel.setFont(this.font);
        // View Buttons
        predictToggle = new Toggle(control, "Prediction");
        predictToggle.setSize(50,20);
        pathToggle = new Toggle(control, "Path");
        pathToggle.setSize(50, 20);
        followToggle = new Toggle(control, "Follow");
        followToggle.setSize(50, 20);

        fieldStarter = new Button(control, "Start Field");
        fieldStarter.setSize(200, 100);
        fieldStarter.registerTooltip("START");
        
        testSlider = new Slider(control, "Speed");
        testSlider.setSize(200, 10);

    }

    public void render() {
        pushMatrix();
        translate(0, this.curHeight);
        fill(255, 100);
        stroke(27, 196, 245);
        rect(0, 0, width-1, 210, 10);
        viewLabel.draw(this.sketch);
        algLabel.draw(this.sketch);
        predictToggle.setPosition(100,curHeight+50);
        pathToggle.setPosition(100, curHeight+100);
        followToggle.setPosition(100, curHeight+150);
        fieldStarter.setPosition(400, curHeight+50);
        testSlider.setPosition(400, curHeight);
        popMatrix();
    }

    public void show() {
        this.vis = true;
        this.curHeight = lerp(this.curHeight, 800, 0.2f);
    }

    public void hide() {
        this.vis = false;
        this.curHeight = lerp(this.curHeight, height+1, 0.1f);
    }
}
class Machine {
      PVector pos;
      PVector follow;
      float angle;

    Machine(PVector wheelPos) {
        this.pos = new PVector(wheelPos.x-20, wheelPos.y);
        this.follow = wheelPos;
        this.angle = 0;
    }


    public void show() {
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

    public void changeAngle() {
        float dx = this.follow.x - this.pos.x;
        float dy = this.follow.y - this.pos.y;
        float angle = atan2(dy, dx);
        this.angle = angle;
    }

    public void changePos() {
        this.pos.x = this.follow.x - cos(this.angle) * 20;
        this.pos.y = this.follow.y - sin(this.angle) * 20;
    }

    public float getAngle() {
        return this.angle;
    }
}
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
    public void show() {
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

    public void showLeft() {
        pushMatrix();
        translate(-5, 0);
        rotate(this.drawAngle);
        line(0, -3, 0, 3);
        popMatrix();
    }

    public void showRight() {
        pushMatrix();
        translate(5, 0);
        rotate(this.drawAngle);
        line(0, -3, 0, 3);
        popMatrix();
    }

    public void maintain() {
        this.drawAngle = this.steeringAngle + this.heading;
        this.drawAngle -= this.heading;
    }

    public void turn(float a) {
        this.steeringAngle += a;
    }


    public void roll() {
        PVector p = PVector.fromAngle(this.steeringAngle+this.heading);
        this.vel = p.div(2);
        this.pos.add(this.vel);
    }

// Used to get machine heading
    public void takeAgent(Agent agent) {
        this.agent = agent;
    }

}
  public void settings() {  size(1000, 1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_180924a" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
