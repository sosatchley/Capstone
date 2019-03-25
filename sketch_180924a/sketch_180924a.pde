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
float scale;
float xOffset = 0.0;
float yOffset = 0.0;
boolean predict = false;
boolean path = false;
boolean reset = false;
boolean follow = false;
boolean pan = false;
boolean controller = false;
ControlP5 control;

void setup() {
    frameRate(60);
  size(1000, 1000);
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
    if (controller) {
        agent.controller.control();
    }
    popMatrix();
    hud.render();
}

void mouseListener() {
    if (mouseY > 900) {
        hud.show();
    }
    else if (mouseY < 700) {
        hud.hide();
    }
}

void mousePressed() {
  xOffset = mouseX-bx;
  yOffset = mouseY-by;
}

void mouseDragged() {
    if (!hud.vis){
        pan = true;
        reset = false;
        hud.followToggle.setValue(false);
        bx = mouseX-xOffset;
        by = mouseY-yOffset;
    }
}

void mouseWheel(MouseEvent event) {
    pan = true;
    follow = false;
    reset = false;
    float e = event.getCount()*-1;
    scale += e/10;
    if (scale < .48) {
        scale = .5;
    } else if (scale > 3.5) {
        scale = 3.5;
    }
}

void hudListener() {
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
    if (hud.controller.getState()) {
        controller = true;
    } else {
        controller = false;
    }

    if (hud.resetView.isPressed()) {
        hud.followToggle.setValue(false);
        pan = false;
        reset = true;
    }
    if (hud.verticies.getState()) {
        field.showVerticies = true;
    } else {
        field.showVerticies = false;
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

void follow() {
    PVector pos = agent.wheels.pos;
    bx = (width/2)-pos.x;
    by = (width/2)-pos.y;
    // scale = 1;
    translate(bx, by);
    zoom(pos.x, pos.y);
}

void reset() {
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

void zoom(float x, float y) {
    translate(x, y);
    scale(scale);
    translate(-x, -y);
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

void exit() {
  this.agent.controller.printQ();
  super.exit();
}
