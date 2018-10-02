// Shane Atchley
// CSCI 410
// Auto-Steer Simulation


Agent agent;

void setup() {
  size(1000, 1000);
  agent = new Agent();
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
        System.out.println("Pressed up");
        agent.roll();
    }
}

void keyReleased() {
    agent.stop();
}
