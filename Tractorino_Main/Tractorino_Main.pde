// Shane Atchley
// CSCI 410
// Auto-Steer Simulation
import controlP5.*;
import java.util.Set;

Agent agent;
HUD hud;
Field field;
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

void settings() {
    this.verticalResolution = (displayHeight/10) * 9;
    size(verticalResolution, verticalResolution);
    // size(1000, 1000);
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
}

void mousePressed() {
  xOffset = mouseX-bx;
  yOffset = mouseY-by;
  if (this.field != null && this.field.waiting) {
      if (control.getController("Place Field").isMouseOver()) {

      } else {
          this.field.beginDrawing(mouseX, mouseY);
      }
  }
  if (this.agent != null && this.agent.placing) {
      if (control.getController("Place Agent").isMouseOver()) {

      } else {
          this.agent.setStartingPosition(mouseX, mouseY);
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

void hudListener() {
    // if (this.hud.placingField) {
    //     this.field = new field();
    // }
}

void drawView() {
    println(hud.currentView);
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
    if (field == null) {
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
        // field = new Field();
        hud.currentView = ViewMode.FOLLOW;
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
