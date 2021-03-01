// Shane Atchley
// CSCI 410
// Auto-Steer Simulation

import java.util.Set;

Agent agent;
HUD hud;
Field field;
Error err;
FieldLoader fl;
int state;
int verticalResolution;
float bx;
float by;
float scale;
float xOffset = 0.0;
float yOffset = 0.0;
boolean controller = false;
ControlP5 control;
ViewMode currentView;
DrawnRegion waitingShape;

void settings() {
    this.verticalResolution = (displayHeight/10) * 9;
    // this.verticalResolution = 500;
    size(verticalResolution, verticalResolution);
}

void setup() {
  frameRate(60);
  // fullScreen();
  control = new ControlP5(this);
  bx = 0;
  by = 0;
  scale = 1;
  hud = new HUD(this);
  state = 0;
  currentView = ViewMode.FOLLOW;
  fl = new FieldLoader();
}

void draw() {
    hudListener();
    background(0);
    pushMatrix();
    // stateListener();
    // drawView();
    if (field != null) {
        field.render();
    }
    if (agent != null) {
        agent.render();
    }
    popMatrix();
    hud.render();
    if (err != null) {
        err.render();
    }
}

void mousePressed(MouseEvent click) {
    float clickX = click.getX();
    float clickY = click.getY();
    xOffset = clickX-bx;
    yOffset = clickY-by;
    if (!hud.isMouseOver()) {
        if (waitingShape != null && waitingShape.waiting) {
            waitingShape.beginDrawing(clickX, clickY);
        }
        if (this.agent != null && this.agent.placing) {
            if (field.pointIsInField(clickX, clickY)) {
                this.agent.setStartingPosition(clickX, clickY);
            } else {
                this.err = new Error(clickX, clickY, ErrorCode.AGENT_PLACEMENT);
            }
        }
    }
}

void mouseDragged() {
    if (this.field == null) {
        // this.field = new Field(mouseX, mouseY);
        // hud.currentView = ViewMode.FOLLOW;
    } else if (this.field.drawing) {
        return;
    } else if (!hud.vis) {
        hud.currentView = ViewMode.PAN;
        bx = mouseX-xOffset;
        by = mouseY-yOffset;
    }
}

void mouseWheel(MouseEvent event) {
    // hud.currentView = ViewMode.PAN;
    float e = event.getCount()*-1;
    scale += e/10;
    if (scale < .48) {
        scale = .5;
    } else if (scale > 3.5) {
        scale = 3.5;
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
        // hud.viewButtonPressed();
    } else if (keyCode == ESC) {
        // field = new Field();
        hud.currentView = ViewMode.FOLLOW;
    }
}

void hudListener() {
    // if (this.hud.placingField) {
    //     this.field = new field();
    // }
}

void drawView() {
    // println(hud.currentView);
    // switch(hud.currentView) {
    //     case PAN :
    //         pan();
    //         break;
    //     case FOLLOW :
    //         follow();
    //         break;
    //     case CENTER :
    //         reset();
    //         break;
    // }
}

void pan() {
    // hud.viewButton.setLabel("Follow");
    // translate(bx, by);
    // if (field != null && !field.drawing) {
    //     zoom(field.center.x, field.center.y);
    // }
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
    if (field == null || field.waiting || field.drawing) {
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

void zoom(float x, float y) {
    translate(x, y);
    scale(scale);
    translate(-x, -y);
}

void keyReleased() {
    //Record wheel to machine heading ratio at end of turn, turn wheels after release to maintain ratio
}

void clearCanvas() {
    this.field = null;
    this.agent = null;
    this.waitingShape = null;
}

void exit() {
  // if (this.agent.controller.QTable != null) {
    // this.agent.controller.printQ();
  // }
  super.exit();
}
