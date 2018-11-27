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
float scale;
float xOffset = 0.0f;
float yOffset = 0.0f;
boolean predict = false;
boolean path = false;
boolean reset = false;
boolean follow = false;
boolean pan = false;
ControlP5 control;

public void setup() {
    frameRate(60);
  
  // fullScreen();
  control = new ControlP5(this);
  bx = 0;
  by = 0;
  scale = 1;
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
    if (field.complete) {
        agent.controller.control();
    }
    popMatrix();
    hud.render();
}

public void mouseListener() {
    if (mouseY > 900) {
        hud.show();
    }
    else if (mouseY < 700) {
        hud.hide();
    }
}

public void mousePressed() {
  xOffset = mouseX-bx;
  yOffset = mouseY-by;
}

public void mouseDragged() {
    if (!hud.vis){
        pan = true;
        reset = false;
        hud.followToggle.setValue(false);
        bx = mouseX-xOffset;
        by = mouseY-yOffset;
    }
}

public void mouseWheel(MouseEvent event) {
    pan = true;
    follow = false;
    reset = false;
    float e = event.getCount()*-1;
    scale += e/10;
    if (scale < .48f) {
        scale = .5f;
    } else if (scale > 3.5f) {
        scale = 3.5f;
    }
}

public void hudListener() {
    agent.wheels.speedMult = hud.testSlider.getValue();
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
                zoom(width/2, height/2);
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
            // agent.autoSteer(this.field);
            if (follow) {
                follow();
                pan = false;
                reset = false;
            } else if (pan) {
                translate(bx, by);
                zoom(field.center.x, field.center.y);
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
        if (field.yScale > field.xScale) {
            scale = field.xScale;
        } else {
            scale = field.yScale;
        }
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

    public void render() {
        this.wheels.show();
        if (this.field != null) {
            setClosestVert();
        }
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

    public void loopCheck() {
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

    public void setLastVert(Vertex vert) {
        this.lastVertex = vert;
    }

    public void setClosestVert() {
        this.closestVertex = this.wheels.findClosest();
    }

    public void setDistance(float distance) {
        this.dist = distance;
    }

    public void setCutterAngle(float angle) {
        float cutterAngle = abs(abs(angle) - abs(this.wheels.heading));
        this.cutterAngle = cutterAngle;
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

    public void getAngle() {
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
                    println("P: " + coord(p));
                    println("Q: " + coord(q));
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
    float alpha = 1.0f;
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
        float angleClosest = this.agent.closestVertex.angle;
        float cutterAngle = degrees(this.agent.cutterAngle);

        int state = getState(distClosest, angleClosest, cutterAngle);
        float reward = getReward(state);
        int action;
        if (this.count < 1000) {
            action = pickAction(state);
        } else {
            action = pickMaxAction(state);
        }
        int statePrime = applyAction(action);
        float update = (1-alpha) * rewardFromTable(state, action) +
                    alpha*(reward + gamma * pickMaxAction(statePrime));
        updateTable(state, action, update);
        for (int j = 0; j < QTable.length; j++) {
            for (int i = 0; i < QTable[j].length; i++) {
                System.out.print("[" + visits[j][i] + "]");
            }
            System.out.println("");
        }
        System.out.println("---------");
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
                return -1.0f;
        case 7:
                return -1.0f;
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
        float angleClosest = this.agent.closestVertex.angle;
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
    HUD hud;
    Boolean begun;
    Boolean drawing;
    Boolean complete;
    PShape shape;
    PShape start;
    PShape cutPath;
    float startx;
    float starty;
    PVector minX;
    PVector maxX;
    PVector minY;
    PVector maxY;
    int v;
    int side;
    Agent agent;
    PVector center;
    float fieldWidth;
    float fieldHeight;
    float xScale;
    float yScale;
    ArrayList<Vertex> verticies;
    Vertex lastVertex;

    // Util u = new Util();


    Field(Agent agent) {
        this.agent = agent;
        this.v = 0;
        this.begun = false;
        this.drawing = false;
        this.complete = false;
    }

    public void startField(HUD hud) {
        this.verticies = new ArrayList<Vertex>();
        this.hud = hud;
        this.side = hud.sideToggle.getBooleanValue() ? 90 : -90;
        this.hud.fieldStarter.setOn();
        this.startx = this.agent.getAxle().pos.x;
        this.starty = this.agent.getAxle().pos.y;
        this.minX = null;
        this.maxX = null;
        this.minY = null;
        this.maxY = null;
        stroke(255, 0, 0);
        noFill();
        PVector p = angularDisplacement(this.startx, this.starty, 18, this.agent.getHeading(), -this.side);
        this.startx = p.x;
        this.starty = p.y;
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
            float frontx = this.agent.getAxle().pos.x;
            float fronty = this.agent.getAxle().pos.y;
            // pushMatrix();
            shape(this.start);
            // scale(2);
            // translate(x, y);
            updateShape(frontx, fronty);
            // popMatrix();
        }
        if (frameCount % 10 == 0) {
            cut(this.agent.cutter.pos.x, this.agent.cutter.pos.y);
        }
        if (this.shape != null) {
            shape(this.shape);
            shape(this.cutPath);
        }
        if (this.complete) {
            this.agent.loopCheck();
            for (int i = 0; i < this.verticies.size(); i++) {
                Vertex vertex = this.verticies.get(i);
                vertex.render();
            }
        }
    }

    public void cut(float x, float y) {
        this.cutPath.vertex(x, y);

        // float Lx = x + 9 * cos(this.agent.wheels.heading - this.side);
        // float Ly = y + 9 * sin(this.agent.wheels.heading - this.side);
        // float Rx= x + 9 * cos(this.agent.wheels.heading + this.side);
        // float Ry = y + 9 * sin(this.agent.wheels.heading + this.side);
        //
        // int count = this.cutPath.getVertexCount();
        // if (count < 2) {
        //     this.cutPath.vertex(Lx, Ly);
        //     this.cutPath.vertex(Rx, Ry);
        // } else {
        //     // if ((count/2) % 2 == 0) {
        //         this.cutPath.vertex(Lx, Ly);
        //         this.cutPath.vertex(Rx, Ry);
        //         for (int i = count/2+1; i < count+1; i++) {
        //             this.cutPath.setVertex(i+2, this.cutPath.getVertex(i));
        //         }
        //         this.cutPath.setVertex(count/2+1, Lx, Ly);
        //         this.cutPath.setVertex(count/2+1, Rx, Ry);
        //         PVector p = new PVector();
        //         this.cutPath.getVertex(count/2+1, p);
        //         stroke(255);
        //         strokeWeight(15);
        //         point(p.x, p.y);
            // } else {
            //     this.cutPath.vertex(Lx, Ly);
            //     this.cutPath.vertex(Rx, Ry);
            //     for (int i = count/2+1; i < count+1; i++) {
            //         setVertex(i+2, getVertex(i));
            //     }
            //     setVertex(count/2+1, Lx, Ly);
            //     setVertex(count/2+1, Rx, Ry);
            // }
        // }
    }

    public void updateShape(float x, float y) {
        // FIXME: Something about where edge of field is drawn in relation to first pass
        //              Left Wheel? Draw field remaining after first pass?
        //              Right Wheel? Draw entire field, begin showing coverage during first pass?
        if (!complete(x, y)) {
            float x1 = x + 9 * cos(this.agent.wheels.heading - this.side);
            float y1 = y + 9 * sin(this.agent.wheels.heading - this.side);

            this.shape.vertex(x1, y1);
            if (this.verticies.size() == 0) {
                Vertex vertex = new Vertex(agent, angularDisplacement(this.agent.cutter.pos, 9, this.agent.cutter.angle, -this.side), this.agent.getHeading(), side);
                this.verticies.add(vertex);
            } else {//if (frameCount % 2 == 0){
                Vertex vertex = new Vertex(agent, angularDisplacement(this.agent.cutter.pos, 9, this.agent.cutter.angle, -this.side), this.agent.getHeading(), verticies.get(verticies.size()-1), side);
                this.verticies.add(vertex);
            }
            this.v++;
            // point(x,y);
        }
    }

    public Boolean complete(float x, float y) {
        if (this.v < 200) {
            return false;
        }
        if (( x > this.startx-15 && x < this.startx + 15) && (y > this.starty-15 && y < this.starty + 15)) {
            this.shape.fill(87, 43, 163, 80);
            this.shape.endShape(CLOSE);
            for (int i = 0; i < this.shape.getVertexCount()-1; i++) {
                PVector vertex = this.shape.getVertex(i);
                // println(coord(vertex));
                strokeWeight(10);
                stroke(255, 0, 0);
                point(vertex.x, vertex.y);
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

            this.center = new PVector((field.maxX.x+field.minX.x)/2, (field.maxY.y+field.minY.y)/2);
            this.fieldWidth = this.maxX.x - this.minX.x;
            this.fieldHeight = this.maxY.y - this.minY.y;
            this.xScale = width/this.fieldWidth;
            this.yScale = height/this.fieldHeight;


            this.hud.fieldStarter.setOff();
            this.hud.resetView.mousePressed();
            this.hud.resetView.mouseReleased();
            this.hud.followToggle.setLock(false);
            this.hud.followToggle.setValue(false);
            this.hud.resetView.setLock(false);
            this.v = 0;
            this.agent.field(this);
            this.agent.wheels.setVerts(this.verticies);
            // this.agent.controller = new Controller(this.agent);
            return true;
        }
        return false;
    }

    public void vertCheck(int loopCount) {
        // println("clear");
        for (Vertex vertex : this.verticies) {
            if (loopCount - vertex.moves > 1) {
                vertex.deprecated = true;
                vertex = null;
            }
        }
        this.agent.wheels.setVerts(this.verticies);
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
    Toggle sideToggle;
    boolean Prediction;
    Button fieldStarter;
    Button resetView;
    Slider testSlider;

// TODO: Add program restart. Use redraw()

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

        sideToggle = new Toggle(control, "Outside");
        sideToggle.setSize(50, 20);
        sideToggle.setMode(ControlP5.SWITCH);

        fieldStarter = new Button(control, "Start");
        fieldStarter.setSize(200, 100);
        fieldStarter.setSwitch(true);
        fieldStarter.setOff();

        testSlider = new Slider(control, "Speed");
        testSlider.setSize(200, 10);
        testSlider.setMin(0.5f);
        testSlider.setMax(3.0f);
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
        sideToggle.setPosition(width/2-25, curHeight +  25);
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

    public void render() {
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

    public int getColor() {
        if (this.neighbor == null) {
            return color(0, 136, 255);
        }
        // FIXME: Make these values less arbitrary, so they can be reactive to changes in vertex interval
        float diff = calcSlope();
        if (abs(diff) < .002f) {
            return color(0, 255, 0);
        } else if (abs(diff) < .006f) {
            return color(219, 255, 0);
        } else if (abs(diff) < .01f) {
            return color(255, 153, 0);
        } else if (abs(diff) < .1f) {
            return color(255, 0, 0);
        } else {
            return color(0, 136, 255);
        }
    }

    public float calcSlope() {
        return abs(this.angle - this.neighbor.angle);
    }

    public void move(Cutter cutter) {
        this.agent.setLastVert(this);
        PVector p = angularDisplacement(x, y, 9+passBy(cutter), this.angle, -this.side);
        this.x = p.x;
        this.y = p.y;
        this.angle = cutter.angle;
        this.moves++;
    }

    public boolean passed(Cutter cutter) {
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

    public float passBy(Cutter cutter) {
        return dist(cutter.pos.x, cutter.pos.y, this.x, this.y);
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
    ArrayList<Vertex> verts;

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

    public void setVerts(ArrayList<Vertex> verts) {
        this.verts = verts;
    }

    public Vertex findClosest() {
        float thisDist;
        float dist = 0;
        Vertex closest = null;
        for (Vertex vert : this.verts) {
            thisDist = dist(this.pos.x, this.pos.y, vert.x, vert.y);
            if (thisDist < dist || dist == 0) {
                if (abs(degrees(atan2(vert.y, vert.x))) < 90) {
                    closest = vert;
                    dist = thisDist;
                }
            }
            strokeWeight(10);
            stroke(255);
        }
        this.agent.setDistance(dist);
        return closest;
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
