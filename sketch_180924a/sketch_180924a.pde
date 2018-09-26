// Shane Atchley
// CSCI 410
// Auto-Steer Simulation


Agent t;

void setup() {
  size(1000, 1000);
  t = new Agent();
}

void draw() {
  background(0);
  t.display();
  t.turn();
  t.update();
}

void keyPressed() {
  if (keyCode == RIGHT) {
    t.setRotation(0.1);
  } else if (keyCode == LEFT) {
    t.setRotation(-0.1);
  } else if (keyCode == UP) {
    t.throttle();
  }
}

void keyReleased() {
  t.setRotation(0);
}