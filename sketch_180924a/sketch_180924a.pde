// Shane Atchley
// CSCI 410
// Auto-Steer Simulation
import controlP5.*;
// import ViewModes;

public Agent agent;
HUD hud;
Field field;
int state;
float bx;
float by;
float scale;
float xOffset = 0.0;
float yOffset = 0.0;
boolean controller = false;
ControlP5 control;
ViewMode currentView;

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
  currentView = ViewMode.FOLLOW;
}

void draw() {
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
        hud.currentView = ViewMode.PAN;
        bx = mouseX-xOffset;
        by = mouseY-yOffset;
    }
}

void mouseWheel(MouseEvent event) {
    hud.currentView = ViewMode.PAN;
    float e = event.getCount()*-1;
    scale += e/10;
    if (scale < .48) {
        scale = .5;
    } else if (scale > 3.5) {
        scale = 3.5;
    }
}

void hudListener() {
    agent.wheels.speedMult = hud.speedSlider.getValue();
    if (hud.fieldStarter.isPressed()) {
        field.startField(hud);
    }
    if (hud.controller.getState()) {
        controller = true;
    } else {
        controller = false;
    }
}

void drawView() {
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

void pan() {
    hud.viewButton.setLabel("Follow");
    translate(bx, by);
    zoom(field.center.x, field.center.y);
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
    }
}

void keyReleased() {
    //Record wheel to machine heading ratio at end of turn, turn wheels after release to maintain ratio
}

void exit() {
  if (this.agent.controller.QTable != null) {
    this.agent.controller.printQ();
  }
  super.exit();
}
