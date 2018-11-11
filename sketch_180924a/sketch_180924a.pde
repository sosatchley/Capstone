// Shane Atchley
// CSCI 410
// Auto-Steer Simulation
import controlP5.*;

public Agent agent;
HUD hud;
Field field;
int state;
float bx;
float by;
float xOffset = 0.0;
float yOffset = 0.0;
boolean predict = false;
boolean path = false;
boolean reset = false;
boolean follow = false;
boolean pan = false;
ControlP5 control;

void setup() {
  size(1000, 1000);
  // fullScreen();
  control = new ControlP5(this);
  bx = 0;
  by = 0;
  agent = new Agent();
  field = new Field(agent);
  hud = new HUD(this, control, field);
  state = 0;
}

void draw() {
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

void mouseListener() {
    if (mouseY > 900) {
        hud.show();
    }
    else if (mouseY < 800) {
        hud.hide();
    }
}

void mousePressed() {
  xOffset = mouseX-bx;
  yOffset = mouseY-by;
}

void mouseDragged() {
    pan = true;
    reset = false;
    hud.followToggle.setValue(false);
    bx = mouseX-xOffset;
    by = mouseY-yOffset;
}

void hudListener() {
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

void stateListener() {
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

void follow() {
    PVector pos = agent.wheels.pos;
    bx = (width/2)-pos.x;
    by = (width/2)-pos.y;
    translate(bx, by);
}

void reset() {
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

void keyPressed() {
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

void keyReleased() {
    //Record wheel to machine heading ratio at end of turn, turn wheels after release to maintain ratio
}

public void test() {
    System.out.println("test");
}
