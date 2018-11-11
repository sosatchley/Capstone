// Shane Atchley
// CSCI 410
// Auto-Steer Simulation
import controlP5.*;

public Agent agent;
HUD hud;
Field field;
float bx;
float by;
float xOffset = 0.0;
float yOffset = 0.0;
boolean center = false;
ControlP5 control;

void setup() {
  // size(1000, 1000);
  control = new ControlP5(this);
  fullScreen();
  bx = 0;
  by = 0;
  agent = new Agent();
  field = new Field(agent);
  hud = new HUD(this, control, field);
}

void draw() {
  background(0);
  // drawGrid(100);
  if (hud.predictToggle.getState()) {
      println("Toggle!");
  }
  pushMatrix();
  if (field.drawing) {
      follow();
  }
  if (field.begun && !field.drawing) {
      center();
  }
  if (center) {
      center();
  }
  if (field.begun) {
      field.render();
  }
  agent.render();
  popMatrix();
  hud.render();
  mouseListener();
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
    bx = mouseX-xOffset;
    by = mouseY-yOffset;
}

void follow() {
    PVector pos = agent.wheels.pos;
    translate((width/2)-pos.x, (height/2)-pos.y);
}

void center() {
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
    println("Min X: " + field.minX.x);
    println("Min Y: " + field.minY.y);
    println("Max X: " + field.maxX.x);
    println("Max Y: " + field.maxY.y);
    println("Center: " + coord(center));
    println(fieldWidth + " pixels by " + fieldHeight);
    translate((width/2)-center.x, (height/2)-center.y);
    strokeWeight(10);
    stroke(255,0,0);
    translate(center.x, center.y);
    scale(scale-(scale/10));
    translate(-center.x, -center.y);
    point(center.x, center.y);
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
        field.startField();
    } else if (key == 'c') {
        if (!center) {
            center = true;
        } else {
            center = false;
        }
    }
}

void keyReleased() {
    //Record wheel to machine heading ratio at end of turn, turn wheels after release to maintain ratio
}

public void test() {
    System.out.println("test");
}
