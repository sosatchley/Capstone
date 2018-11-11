import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
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


public Agent agent;
HUD hud;
Field field;
int state;
float bx;
float by;
float xOffset = 0.0f;
float yOffset = 0.0f;
boolean predict = false;
boolean path = false;
boolean reset = false;
boolean follow = false;
boolean pan = false;
ControlP5 control;

public void setup() {
  
  // fullScreen();
  control = new ControlP5(this);
  bx = 0;
  by = 0;
  agent = new Agent();
  field = new Field(agent);
  hud = new HUD(this, control, field);
  state = 0;
}

public void draw() {
    mouseListener();
    hudListener();
    background(0);
    pushMatrix();
    stateListener();
    if (field.begun) {
        field.render();
    }
    agent.render();
    popMatrix();
    hud.render();
}

public void mouseListener() {
    if (mouseY > 900) {
        hud.show();
    }
    else if (mouseY < 800) {
        hud.hide();
    }
}

public void mousePressed() {
  xOffset = mouseX-bx;
  yOffset = mouseY-by;
}

public void mouseDragged() {
    pan = true;
    reset = false;
    hud.followToggle.setValue(false);
    bx = mouseX-xOffset;
    by = mouseY-yOffset;
}

public void hudListener() {
    if (hud.predictToggle.getState()) {
        predict = true;
    } else {
        predict = false;
    }
    if (hud.pathToggle.getState()) {
        path = true;
    } else {
        path = false;
    }
    if (hud.followToggle.getState()) {
        follow = true;
        pan = false;
        reset = false;
    } else {
        follow = false;
    }
    if (hud.fieldStarter.isPressed()) {
        field.startField(hud);
    }

    if (hud.resetView.isPressed()) {
        hud.followToggle.setValue(false);
        pan = false;
        reset = true;
    }
}

public void stateListener() {
    if (!field.begun) {
        state = 0;
    } else if (field.drawing) {
        state = 1;
    } else if (field.complete) {
        state = 2;
    }
    switch(state) {
        case(0) :
            if (pan) {
                translate(bx, by);
            } else if (follow) {
                follow();
            } else {
                bx = 0;
                by = 0;
                translate(bx, by);
            }
            break;
        case(1) :
            hud.followToggle.setValue(true);
            hud.followToggle.setLock(true);
            hud.resetView.setLock(true);
            follow = true;
            follow();
            break;
        case(2) :
            if (follow) {
                follow();
                pan = false;
                reset = false;
            } else if (pan) {
                translate(bx, by);
            } else {
                reset = true;
                reset();
            }
        }
}

public void follow() {
    PVector pos = agent.wheels.pos;
    bx = (width/2)-pos.x;
    by = (width/2)-pos.y;
    translate(bx, by);
}

public void reset() {
    if (!field.begun) {
        bx = 0;
        by = 0;
        translate(bx, by);
    } else {
        PVector center = new PVector((field.maxX.x+field.minX.x)/2, (field.maxY.y+field.minY.y)/2);
        float fieldWidth = field.maxX.x - field.minX.x;
        float fieldHeight = field.maxY.y - field.minY.y;
        float min;
        float scale;
        float yScale = height/fieldHeight;
        float xScale = width/fieldWidth;
        if (yScale>xScale) {
            scale = xScale;
        } else {
            scale = yScale;
        }
        bx = (width/2)-center.x;
        by = (height/2  )-center.y;
        translate(bx, by);
        strokeWeight(10);
        stroke(255,0,0);
        translate(center.x, center.y);
        scale(scale-(scale/10));
        translate(-center.x, -center.y);
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
    } else if (key == ' ') {
        field.startField(hud);
    } else if (key == 'c') {
        if (!reset) {
            reset = true;
        } else {
            reset = false;
        }
    }
}

public void keyReleased() {
    //Record wheel to machine heading ratio at end of turn, turn wheels after release to maintain ratio
}

public void test() {
    System.out.println("test");
}
class Agent {
    Wheels wheels;
    Axle axle;
    Machine machine;
    Cutter cutter;
    PVector pos;

    Agent() {
        this.wheels = new Wheels();
        this.machine = new Machine(this.wheels.pos);
        this.axle = new Axle(this.machine, this.wheels);
        this.cutter = new Cutter(this.machine.pos);
        this.wheels.takeAgent(this);
        this.pos = this.machine.pos;
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

    public Wheels getWheels() {
        return this.wheels;
    }

    public Axle getAxle() {
        return this.axle;
    }

    public Machine getMachine() {
        return this.machine;
    }

    public Cutter getCutter() {
        return this.cutter;
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
    HUD hud;
    Boolean begun;
    Boolean drawing;
    Boolean complete;
    PShape shape;
    PShape start;
    float startx;
    float starty;
    PVector minX;
    PVector maxX;
    PVector minY;
    PVector maxY;
    int v;
    Agent agent;
    // Util u = new Util();


    Field(Agent agent) {
        this.agent = agent;
        this.v = 0;
        this.begun = false;
        this.drawing = false;
        this.complete = false;
    }

    public void startField(HUD hud) {
        this.hud = hud;
        this.hud.fieldStarter.setOn();
        this.startx = this.agent.getAxle().pos.x;
        this.starty = this.agent.getAxle().pos.y;
        this.minX = null;
        this.maxX = null;
        this.minY = null;
        this.maxY = null;
        stroke(255, 0, 0);
        noFill();
        this.start = createShape(RECT, this.startx-15,this.starty-15, 30, 30);
        this.shape = createShape();
        this.shape.beginShape();
        this.shape.stroke(112, 143, 250);
        this.drawing = true;
        this.begun = true;
    }

    public void render() {
        if (this.drawing) {
            // pushMatrix();
            shape(this.start);
            float x = this.agent.getAxle().pos.x;
            float y = this.agent.getAxle().pos.y;
            // scale(2);
            // translate(x, y);
            updateShape(x, y);
            // popMatrix();
        }
        if (this.shape != null) {
            shape(this.shape);
        }
    }

    public void updateShape(float x, float y) {
        // FIXME: Something about where edge of field is drawn in relation to first pass
        //              Left Wheel? Draw field remaining after first pass?
        //              Right Wheel? Draw entire field, begin showing coverage during first pass?
        if (!complete(x, y)) {
            this.shape.vertex(x, y);
            this.v++;
            point(x,y);
        }
    }

    public Boolean complete(float x, float y) {
        if (this.v < 200) {
            return false;
        }
        if (( x > this.startx-15 && x < this.startx + 15) && (y > this.starty-15 && y < this.starty + 15)) {
            this.shape.fill(87, 43, 163, 50);
            this.shape.endShape(CLOSE);
            for (int i = 0; i < this.shape.getVertexCount()-1; i++) {
                PVector vertex = this.shape.getVertex(i);
                if (this.minX == null || this.minX.x > vertex.x) {
                    this.minX = vertex;
                }
                if (this.maxX == null || this.maxX.x < vertex.x) {
                    this.maxX = vertex;
                }
                if (this.minY == null || this.minY.y > vertex.y) {
                    this.minY = vertex;
                }
                if (this.maxY == null || this.maxY.y < vertex.y) {
                    this.maxY = vertex;
                }
            }
            this.drawing = false;
            this.complete = true;
            this.hud.fieldStarter.setOff();
            this.hud.resetView.mousePressed();
            this.hud.resetView.mouseReleased();
            this.hud.followToggle.setLock(false);
            this.hud.followToggle.setValue(false);
            this.hud.resetView.setLock(false);
            this.v = 0;
            println("just 1");
            // this.start.setVisable(false);
            return true;
        }
        return false;
    }
}

class HUD {
    PApplet sketch;
    ControlP5 control;
    Field field;
    float curHeight;
    int showHeight;
    int hideHeight;
    boolean vis;
    CallbackListener cb;
    Textlabel viewLabel;
    Textlabel algLabel;
    PFont font;
    Toggle predictToggle;
    Toggle pathToggle;
    Toggle followToggle;
    boolean Prediction;
    Button fieldStarter;
    Button resetView;
    Slider testSlider;

    HUD(PApplet sketch, ControlP5 control, Field field) {
        this.sketch = sketch;
        this.control = control;
        this.showHeight = 200;
        this.curHeight = height;
        this.field = field;

        this.vis = false;
        this.font = createFont("OpenSansCondensed-Light.ttf", 32);
        // Labels
        viewLabel = new Textlabel(control, "View", width/10, 10, 150,150);
        algLabel = new Textlabel(control, "Info", width/10*8, 10, 150,150);
        viewLabel.setFont(this.font);
        algLabel.setFont(this.font);
        // View Buttons
        Prediction = false;
        predictToggle = new Toggle(control, "Prediction");
        predictToggle.setSize(50,20);
        pathToggle = new Toggle(control, "Path");
        pathToggle.setSize(50, 20);
        followToggle = new Toggle(control, "Follow");
        followToggle.setSize(50, 20);
        resetView = new Button(control, "reset");
        resetView.setSize(50, 20);

        fieldStarter = new Button(control, "Start");
        fieldStarter.setSize(200, 100);
        fieldStarter.setSwitch(true);
        fieldStarter.setOff();

        testSlider = new Slider(control, "Speed");
        testSlider.setSize(200, 10);
    }



    public void render() {
        pushMatrix();
        translate(0, this.curHeight);
        fill(255, 100);
        if (this.Prediction) {
            fill(255,0,0);
        }
        stroke(27, 196, 245);
        rect(0, 0, width-1, height/5+10, 10);
        viewLabel.draw(this.sketch);
        algLabel.draw(this.sketch);
        predictToggle.setPosition(width/20,curHeight+50);
        pathToggle.setPosition(width/20, curHeight+100);
        followToggle.setPosition(width/20, curHeight+150);
        resetView.setPosition(width/20 + width/10, curHeight + 100);
        fieldStarter.setPosition(width/2-100, curHeight+50);
        testSlider.setPosition(width/2-100, curHeight);
        popMatrix();
    }

    public void show() {
        this.vis = true;
        this.curHeight = lerp(this.curHeight, height/5*4, 0.2f);
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
        this.vel = p.mult(2);
        this.pos.add(this.vel);
    }

// Used to get machine heading
    public void takeAgent(Agent agent) {
        this.agent = agent;
    }

}
// class Util() {
//
//     Util() {}

    public String coord(float x, float y) {
        String coord = "(" + x + ":" + y + ")";
        return coord;
    }

    public String coord(PVector vector) {
        float x = vector.x;
        float y = vector.y;
        String coord = "(" + x + ":" + y + ")";
        return coord;
    }

    public void drawGrid(int cellSize) {
        PFont font = createFont("Georgia", 8);
        textFont(font);
        for (float y = 0; y < height; y+=cellSize) {
            for (float x = 0; x < width; x+=cellSize) {
                line(x,y, x, y+cellSize);
                line(x,y, x+cellSize, y);
                text(coord(x, y), x+1, y+1);
            }
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
