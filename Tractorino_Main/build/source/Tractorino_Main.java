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

public class Tractorino_Main extends PApplet {

// Shane Atchley
// CSCI 410
// Auto-Steer Simulation

// import ViewModes;

public Agent agent;
HUD hud;
Field field;
int state;
int verticalResolution;
float bx;
float by;
float scale;
float xOffset = 0.0f;
float yOffset = 0.0f;
boolean controller = false;
ControlP5 control;
ViewMode currentView;

public void settings() {
    this.verticalResolution = (displayHeight/10) * 9;
    size(verticalResolution, verticalResolution);
    // size(1000, 1000);
}

public void setup() {
  frameRate(60);
  // fullScreen();
  control = new ControlP5(this);
  bx = 0;
  by = 0;
  scale = 1;
  agent = new Agent();
  field = new Field(agent);
  hud = new HUD(this.verticalResolution, control);
  state = 0;
  currentView = ViewMode.FOLLOW;
}

public void draw() {
    mouseListener();
    hudListener();
    background(0);
    pushMatrix();
    // stateListener();
    drawView();
    if (field.begun) {
        field.render();
    }
    agent.render();
    if (controller) {
        agent.controller.control();
    }
    popMatrix();
    hud.render();
}

public void mouseListener() {
    if (mouseY > (this.verticalResolution/10) * 9) {
        hud.show();
    }
    else if (mouseY < (this.verticalResolution/10) * 7) {
        hud.hide();
    }
}

public void mousePressed() {
  xOffset = mouseX-bx;
  yOffset = mouseY-by;
}

public void mouseDragged() {
    if (!hud.vis){
        hud.currentView = ViewMode.PAN;
        bx = mouseX-xOffset;
        by = mouseY-yOffset;
    }
}

public void mouseWheel(MouseEvent event) {
    // hud.currentView = ViewMode.PAN;
    float e = event.getCount()*-1;
    scale += e/10;
    if (scale < .48f) {
        scale = .5f;
    } else if (scale > 3.5f) {
        scale = 3.5f;
    }
}

public void hudListener() {
    agent.wheels.speedMult = hud.speedSlider.getValue();
    if (hud.fieldStarter.isPressed()) {
        field.startField(hud);
    }
    if (hud.controllerToggle.getState()) {
        controller = true;
    } else {
        controller = false;
    }
}

public void drawView() {
    switch(hud.currentView) {
        case PAN :
            pan();
            break;
        case FOLLOW :
            follow();
            break;
        case CENTER :
            reset();
            break;
    }
}

public void pan() {
    hud.viewButton.setLabel("Follow");
    translate(bx, by);
    if (field.complete) {
        zoom(field.center.x, field.center.y);
    }
}

public void follow() {
    PVector pos = agent.wheels.pos;
    bx = (width/2)-pos.x;
    by = (width/2)-pos.y;
    // scale = 1;
    translate(bx, by);
    zoom(pos.x, pos.y);
}

public void reset() {
    if (!field.begun) {
        bx = 0;
        by = 0;
        translate(bx, by);
        scale = 1;
    } else {
        scale = (field.yScale > field.xScale) ? field.xScale : field.yScale;
        bx = (width/2)-field.center.x;
        by = (height/2  )-field.center.y;
        translate(bx, by);
        zoom(field.center.x, field.center.y);
    }
}

public void zoom(float x, float y) {
    translate(x, y);
    scale(scale);
    translate(-x, -y);
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
    }
}

public void keyReleased() {
    //Record wheel to machine heading ratio at end of turn, turn wheels after release to maintain ratio
}

public void exit() {
  if (this.agent.controller.QTable != null) {
    this.agent.controller.printQ();
  }
  super.exit();
}
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

    public void render() {
        this.wheels.show();
        this.axle.show();
        this.machine.show();
        this.cutter.show();
        setCutterAngle(this.cutter.angle);
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
        } else {
        }
    }

    public void roll() {
        this.wheels.rolling = true;
    }

    public void halt() {
        this.wheels.rolling = false;
    }

    public void setDistance(float distance) {
        this.dist = distance;
    }

    public void setCutterAngle(float angle) {
        float cutterAngle = abs(abs(angle) - abs(this.wheels.heading));
        this.cutterAngle = cutterAngle;
    }

    public Wheels getWheels() {
        return this.wheels;
    }

    public float getHeading() {
        return this.wheels.heading;
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

    public void field(Field field) {
        this.field = field;
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
class Controller {
    Agent agent;
    float[][] QTable;
    int[][] visits;
    float gamma = 0.5f;
    float alpha = 0.5f;
    int count = 0;

    Controller(Agent agent) {
        this.agent = agent;
    }

    public void control() {
        if (count < 1) {
            initializeTable();
        }
        count++;
        float distClosest = this.agent.dist;
        float angleClosest = 6;//this.agent.closestVertex.angle;
        float cutterAngle = degrees(this.agent.cutterAngle);

        int state = getState(distClosest, angleClosest, cutterAngle);
        float reward = getReward(state);
        int action;
        if (this.count < 10000) {
            action = pickAction(state);
        } else {
            action = pickMaxAction(state);
        }
        int statePrime = applyAction(action);
        float update = (1-alpha) * rewardFromTable(state, action) +
                    alpha*(reward + gamma * pickMaxAction(statePrime));
        updateTable(state, action, update);
        // for (int j = 0; j < QTable.length; j++) {
        //     for (int i = 0; i < QTable[j].length; i++) {
        //         System.out.print("[" + visits[j][i] + "]");
        //     }
        //     System.out.println("");
        // }
        // System.out.println("---------");
        state = statePrime;
    }

    public void initializeTable() {
        QTable = new float[8][3];
        visits = new int[8][3];
        for (int i = 0; i < QTable.length; i++) {
                for (int j = 0; j < QTable[i].length; j++) {
                        float r = random(0, 1);
                        QTable[i][j] = 0;
                        visits[i][j] = 0;
                }
        }
    }

    public int getState(float distance, float vertAngle, float cutterAngle) {
        if (cutterIsGood(cutterAngle)) {
            if (distIsGood(distance)) {
                if (steeringLess(vertAngle)) {
                    return 0;
                } else {
                    return 1;
                }
            } else {
                if (steeringLess(vertAngle)) {
                    return 2;
                } else {
                    return 3;
                }
            }
        } else {
            if (distIsGood(distance)) {
                if (steeringLess(vertAngle)) {
                    return 4;
                } else {
                    return 5;
                }
            } else {
                if (steeringLess(vertAngle)) {
                    return 6;
                } else {
                    return 7;
                }
            }
        }
    }

    public float getReward(int state) {
        switch(state) {
        case 0:
                return 1.0f;
        case 1:
                return 1.0f;
        case 2:
                return 0.5f;
        case 3:
                return 0.5f;
        case 4:
                return -0.2f;
        case 5:
                return -0.2f;
        case 6:
                return -10.0f;
        case 7:
                return -10.0f;
        }
        return 0.0f;
    }

    public int pickAction(int state) {
        double best = 0.0f;
        int index = 0;
        float r = random(3);
        int f = floor(r);
        // for (int i = 0; i < QTable[state].length; i++) {
        //         if (QTable[state][i] == 0.0) {
        //                 index = i;
        //         } else if (QTable[state][i] > best){
        //             best = QTable[state][i];
        //             index = i;
        //         }
        // }
        visits[state][index] += 1;
        return f;
    }

    public int pickMaxAction(int state) {
        double best = 0.0f;
        int index = 0;
        for (int i = 0; i < QTable[state].length; i++) {
                if (QTable[state][i] > best) {
                        best = QTable[state][i];
                        index = i;
                }
        }
        visits[state][index] += 1;
        return index;
    }

    public int applyAction(int index) {
        switch(index) {
        case 0:
                this.agent.turn(1);
                // println("Went right");
                break;
        case 1:
                this.agent.turn(0);
                // println("Went left");
                break;
        case 2:
                this.agent.turn(2);
                // println("Went straight");
                break;
        }
        float distClosest = this.agent.dist;
        float angleClosest = 6;//this.agent.closestVertex.angle;
        float cutterAngle = this.agent.cutterAngle;
        return getState(distClosest, angleClosest, cutterAngle);
    }

    public void updateTable(int state, int action, float update) {
        QTable[state][action] = update;
    }

    public float rewardFromTable(int state, int action) {
        return QTable[state][action];
    }

    public boolean distIsGood(float dist) {
        System.out.println(dist);
        return dist < 10 ? true : false;
    }

    public boolean cutterIsGood(float angle) {
        return angle < 50 ? true : false;
    }

    public boolean steeringLess(float angle) {
        return abs(angle) > abs(this.agent.wheels.steeringAngle) ? true : false;
    }

    public void printQ() {
        for (int j = 0; j < QTable.length; j++) {
            for (int i = 0; i < QTable[j].length; i++) {
                System.out.print("[" + QTable[j][i] + "]");
            }
            System.out.println("");
        }
        System.out.println("---------");
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
        stroke(255, 0, 0);
        point(0, 0);
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
    Agent agent;
    HUD hud;

    PShape shape;
    PShape start;
    PShape cutPath;

    Boolean begun;
    Boolean drawing;
    Boolean complete;

    int side;
    float xScale;
    float yScale;

    float minX;
    float maxX;
    float minY;
    float maxY;
    PVector center;
    float startx;
    float starty;
    Boolean cursorHasExited;
    float fieldWidth;
    float fieldHeight;

    Field(Agent agent) {
        this.agent = agent;
        this.begun = false;
        this.drawing = false;
        this.complete = false;
    }

    public void startField(HUD hud) {
        this.hud = hud;
        this.hud.fieldStarter.setOn();
        this.hud.currentView = ViewMode.FOLLOW;
        this.hud.viewButton.setLock(true);
        this.hud.viewButton.setLabel("Follow");
        this.startx = mouseX;
        this.starty = mouseY;
        this.cursorHasExited = false;
        this.minX = Float.POSITIVE_INFINITY;
        this.maxX = Float.NEGATIVE_INFINITY;
        this.minY = Float.POSITIVE_INFINITY;
        this.maxY = Float.NEGATIVE_INFINITY;
        stroke(255, 0, 0);
        noFill();
        this.start = createShape(RECT, this.startx-15,this.starty-15, 30, 30);
        this.shape = createShape();
        this.shape.beginShape();
        this.cutPath = createShape();
        this.cutPath.beginShape();
        this.shape.stroke(112, 143, 250);
        this.cutPath.stroke(255,50);
        this.cutPath.strokeWeight(18);
        this.drawing = true;
        this.complete = false;
        this.begun = true;

    }

    public void render() {
        if (this.drawing) {
            shape(this.start);
            updateShape(mouseX, mouseY);
        }
        if (this.shape != null) {
            shape(this.shape);
            shape(this.cutPath);
        }
    }

    public void updateShape(float x, float y) {
        if (!complete(x, y)) {
            this.shape.vertex(x,y);
            updateBoundaries(x, y);
            return;
        }
    }

    public void updateBoundaries(float x, float y) {
        if (this.minX > x) {
            this.minX = x;
        }
        if (this.maxX < x) {
            this.maxX = x;
        }
        if (this.minY > y) {
            this.minY = y;
        }
        if (this.maxY < y) {
            this.maxY = y;
        }
    }

    public Boolean complete(float x, float y) {

        if (cursorReturnedToStartingSquare(x, y)) {
            this.shape.fill(87, 43, 163, 80);
            this.shape.endShape(CLOSE);
            println(this.shape.getWidth());
            this.drawing = false;
            this.complete = true;

            this.center = new PVector((this.maxX + this.minX)/2,
                                      (this.maxY + this.minY)/2);
            this.fieldWidth = this.maxX - this.minX;
            this.fieldHeight = this.maxY - this.minY;
            this.xScale = width/this.fieldWidth;
            this.yScale = height/this.fieldHeight;

            this.hud.currentView = ViewMode.CENTER;
            this.hud.viewButton.setLock(false);
            this.hud.viewButton.setLabel("Follow");
            this.hud.fieldStarter.setOff();
            return true;
        }
        return false;
    }

    public Boolean cursorReturnedToStartingSquare(float x, float y) {
        if (!cursorHasExited) {
            if (cursorInStartingSquare(x, y)) {
                return false;
            } else {
                cursorHasExited = true;
                return false;
            }
        } else {
            if (cursorInStartingSquare(x, y)) {
                return true;
            } else {
                return false;
            }
        }
    }

    public Boolean cursorInStartingSquare(float x, float y) {
        return ((x > this.startx - 15 && x < this.startx + 15) &&
                (y > this.starty - 15 && y < this.starty + 15));
    }
}

class HUD {
    int windowSize;
    ControlP5 control;

    float curHeight;
    int showHeight;
    int hideHeight;

    ViewMode currentView;
    boolean vis;

    Slider speedSlider;
    Toggle sideToggle;
    Toggle controllerToggle;
    Button fieldStarter;
    Button viewButton;
    Button saveFieldButton;
    Button loadFieldButton;
    Button newFieldButton;

// TODO: Add program restart. Use redraw()
//      This is not a use case of redraw()
//
// TODO: Remove 'Prediction'
// TODO: Remove 'Reset Program'
// TODO: Replace 'Vertices', 'controllerToggle (AutoSteer)' with button switches

    HUD(int windowSize, ControlP5 control) {
        this.windowSize = windowSize;
        this.control = control;
        this.showHeight = windowSize/5;
        this.curHeight = height;
        this.currentView = ViewMode.FOLLOW;
        this.vis = false;

        int controlWidth = showHeight/4;
        int controlHeight = showHeight/10;
        ControlFont controlFont = new ControlFont(createFont("Arial",controlHeight/2));

        sideToggle = new Toggle(control, "Outside");
        sideToggle.setSize(controlWidth, controlHeight);
        sideToggle.setMode(ControlP5.SWITCH);
        sideToggle.setFont(controlFont);

        controllerToggle = new Toggle(control, "Controller");
        controllerToggle.setSize(controlWidth, controlHeight);
        controllerToggle.setMode(ControlP5.SWITCH);
        controllerToggle.setValue(false);
        controllerToggle.setFont(controlFont);

        fieldStarter = new Button(control, "Start");
        fieldStarter.setSize(controlWidth, controlHeight);
        fieldStarter.setSwitch(true);
        fieldStarter.setOff();
        fieldStarter.setFont(controlFont);

        speedSlider = new Slider(control, "Speed");
        speedSlider.setSize(showHeight, controlHeight/2);
        speedSlider.setMin(0.5f);
        speedSlider.setMax(3.0f);
        speedSlider.setFont(controlFont);

        viewButton = new Button(control, "Center");
        viewButton.setSize(controlWidth,controlHeight);
        viewButton.setLock(true);
        viewButton.setFont(controlFont);
        viewButton.addCallback(new CallbackListener() {
            public void controlEvent(CallbackEvent e) {
                switch(e.getAction()) {
                    case(ControlP5.ACTION_PRESSED):viewButtonPressed();
                }
            }
        });

        saveFieldButton = new Button(control, "Save");
        saveFieldButton.setSize(controlWidth,controlHeight);
        saveFieldButton.setFont(controlFont);
        saveFieldButton.addCallback(new CallbackListener() {
            public void controlEvent(CallbackEvent e) {
                switch(e.getAction()) {
                    case(ControlP5.ACTION_PRESSED):saveButtonPressed();
                }
            }
        });

        loadFieldButton = new Button(control, "Load");
        loadFieldButton.setSize(controlWidth,controlHeight);
        loadFieldButton.setFont(controlFont);
        loadFieldButton.addCallback(new CallbackListener() {
            public void controlEvent(CallbackEvent e) {
                switch(e.getAction()) {
                    case(ControlP5.ACTION_PRESSED):loadButtonPressed();
                }
            }
        });

        newFieldButton = new Button(control, "New");
        newFieldButton.setSize(controlWidth,controlHeight);
        newFieldButton.setFont(controlFont);
        newFieldButton.addCallback(new CallbackListener() {
            public void controlEvent(CallbackEvent e) {
                switch(e.getAction()) {
                    case(ControlP5.ACTION_PRESSED):newButtonPressed();
                }
            }
        });
    }

    public void render() {
        pushMatrix();
        translate(0, this.curHeight);
        drawPanel();
        drawControls();
        popMatrix();
    }

    public void drawPanel() {
        fill(255, 100);
        stroke(27, 196, 245);
        rect(0, 0, width-1, showHeight+10, 10);
    }

    public void drawControls() {
        speedSlider.setPosition(hudColumn(0), hudRow(0));
        viewButton.setPosition(hudColumn(0), hudRow(1));
        newFieldButton.setPosition(hudColumn(1), hudRow(1));
        loadFieldButton.setPosition(hudColumn(1), hudRow(2));
        saveFieldButton.setPosition(hudColumn(1), hudRow(3));
        sideToggle.setPosition(hudColumn(2), hudRow(1));
        fieldStarter.setPosition(hudColumn(2), hudRow(2));
        controllerToggle.setPosition(hudColumn(2), hudRow(3));
    }

    public void viewButtonPressed() {
        switch(this.currentView) {
            case FOLLOW :
                viewButton.setLabel("Follow");
                this.currentView = ViewMode.CENTER;
                break;
            case CENTER :
                viewButton.setLabel("Center");
                this.currentView = ViewMode.FOLLOW;
                break;
            case PAN :
                viewButton.setLabel("Center");
                this.currentView = ViewMode.FOLLOW;
                break;
        }
    }

    public void newButtonPressed() {

    }

    public void loadButtonPressed() {

    }

    public void saveButtonPressed() {

    }

    public float hudColumn(float columnNumber) {
        float xPosition = ((this.windowSize/100) + (columnNumber * (this.windowSize/10)));
        return xPosition;
    }

    public float hudRow(int rowNumber) {
        float yPosition = ((this.windowSize/100) + (curHeight + (rowNumber*(this.windowSize/20))));
        return yPosition;
    }

    public void show() {
        this.vis = true;
        this.curHeight = lerp(this.curHeight, height-this.showHeight, 0.2f);
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
    float speedMult;
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
        this.speedMult = .5f;
    }

// Renders Wheel object on canvas
    public void show() {
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
        this.vel = p.mult(this.speedMult);
        this.pos.add(this.vel);
    }

// Used to get machine heading
    public void takeAgent(Agent agent) {
        this.agent = agent;
    }

}

// class Util() {
//
//     Util()

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

    public double distance(PVector p, PVector q) {
        float x1 = p.x;
        float x2 = q.x;
        float y1 = p.y;
        float y2 = q.y;
        double dist;
        dist = sqrt(pow((x2-x1), 2)-pow((y2-y1), 2));
        return dist;
    }

    public PVector angularDisplacement(float x, float y, float skew, float baseAngle, float change) {
        float Lx = x + skew * cos(baseAngle - change);
        float Ly = y + skew * sin(baseAngle - change);
        return new PVector(Lx, Ly);
    }

    public PVector angularDisplacement(PVector pos, float skew, float baseAngle, float change) {
        float x = pos.x;
        float y = pos.y;
        float Lx = x + skew * cos(baseAngle - change);
        float Ly = y + skew * sin(baseAngle - change);
        return new PVector(Lx, Ly);
    }
    // float Lx = x + 9 * cos(this.agent.wheels.heading - this.angle);
    // float Ly = y + 9 * sin(this.agent.wheels.heading - this.angle);
    // float Rx= x + 9 * cos(this.agent.wheels.heading + this.angle);
    // float Ry = y + 9 * sin(this.agent.wheels.heading + this.angle);
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Tractorino_Main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
