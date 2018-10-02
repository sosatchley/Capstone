import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

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

public void setup() {
  
  agent = new Agent();
}

public void draw() {
  background(0);
  agent.render();
}

public void keyPressed() {
    if (keyCode == RIGHT) {
        agent.turn(1);
    } else if (keyCode == LEFT) {
        agent.turn(0);
    } else if (keyCode == UP) {
        System.out.println("Pressed up");
        agent.roll();
    }
}

public void keyReleased() {
    agent.stop();
}
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

    public void render() {
        this.wheels.show();
        this.axle.show();
        this.machine.show();
        this.cutter.show();
    }

    public void turn(int dir) {
        if (dir == 1) {

            if ((this.wheels.angle - this.machine.angle) < (degrees(60))) {
                this.wheels.turn(0.1f);
            }
        } else if (dir == 0) {
            if ((this.wheels.angle - this.machine.angle) > (degrees(-60))) {
                this.wheels.turn(-0.1f);
            }
        }
    }

    public void roll() {
        System.out.println("called roll");
        this.wheels.rolling = true;
    }

    public void stop() {
        this.wheels.rolling = false;
    }

    public float degrees(int degrees) {
        float radians = degrees * PI / 180;
        return radians;
    }

}
class Axle {
    float angle;
    PVector pos;

    Axle() {
        this.angle = 0;
        this.pos = new PVector(width/2, height/2);
    }

    public void show() {
        pushMatrix();
        stroke(0,255,0);
        strokeWeight(1);
        translate(this.pos.x, this.pos.y);
        rotate(this.angle + PI/2);
        line(-5, -10, 5, -10);
        popMatrix();
    }

}
class Cutter {
    float angle;
    PVector pos;

    Cutter() {
        this.angle = 0;
        this.pos = new PVector(width/2, height/2);
    }

    public void show() {
        pushMatrix();
        stroke(0,255,0);
        strokeWeight(1);
        translate(this.pos.x, this.pos.y);
        rotate(this.angle + PI/2);
        line(0,10,0,15);
        ellipse(0,24,18,18);
        popMatrix();
    }



}

class Machine {
      PVector pos;
      float angle;

    Machine() {
        this.pos = new PVector(width/2, height/2);
        this.angle = 0;
    }

    public void show() {
        pushMatrix();
        noFill();
        stroke(0,255,0);
        strokeWeight(1);
        translate(this.pos.x, this.pos.y);
        rotate(this.angle + PI/2);
        triangle(-10, 10, 10, 10, 0, -10);
        popMatrix();
    }
}
class Wheels {
    float angle;
    PVector pos;
    PVector vel;
    Boolean rolling;

    Wheels() {
        this.angle = 0;
        this.pos = new PVector(width/2, height/2);
        this.vel = new PVector(0, 0);
        this.rolling = false;
    }

    public void show() {
        pushMatrix();
        stroke(0,0,255);
        strokeWeight(3);
        translate(this.pos.x, this.pos.y);
        rotate(PI/2);
        showLeft();
        showRight();
        popMatrix();
        if (rolling) {
            System.out.println(rolling);
            roll();
        }
    }

    public void showLeft() {
        pushMatrix();
        translate(-5, -10);
        rotate(this.angle);
        line(0, -3, 0, 3);
        popMatrix();
    }

    public void showRight() {
        pushMatrix();
        translate(5, -10);
        rotate(this.angle);
        line(0, -3, 0, 3);
        popMatrix();
    }

    public void turn(float a) {
        this.angle += a;
    }

    public void roll() {
        PVector p = PVector.fromAngle(this.angle);
        this.vel.add(p);
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
