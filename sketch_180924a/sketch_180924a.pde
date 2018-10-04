// Shane Atchley
// CSCI 410
// Auto-Steer Simulation


Agent agent;

void setup() {
  size(1000, 1000);
  agent = new Agent();
  // frameRate(10);
}

void draw() {
  background(0);
  agent.render();
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
    }
}

void keyReleased() {
    //Record wheel to machine heading ratio at end of turn, turn wheels after release to maintain ratio
}
