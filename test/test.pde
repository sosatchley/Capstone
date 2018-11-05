PShape shape;
Boolean running;
float startx;
float starty;
int v;

void setup() {
frameRate(20);
background(0);
stroke(255, 0, 0);
strokeWeight(5);
fill(92, 249, 126);
size(1500,1500);
this.running = false;
}

void draw() {
    if (this.running) {
        updateShape(mouseX, mouseY);
    }
    if (this.shape != null) {
        shape(this.shape);
    }
}
void keyPressed() {
    if (keyCode == UP) {
        test();
    }
}

void test() {
    System.out.println("Running Test");
    running = true;
    this.startx = mouseX;
    this.starty = mouseY;
    rect(this.startx-15, this.starty-15, 30, 30);
    this.v = 0;
    System.out.printf("StartX: %f  StartY: %f \n", this.startx, this.starty);
    this.shape = createShape();
    this.shape.beginShape();
    this.shape.fill(87, 43, 163);
    this.shape.stroke(112, 143, 250);

}

void updateShape(float x, float y) {
    if (!fieldComplete(x, y)) {
        this.shape.vertex(x,y);
        System.out.printf("Vertex @ (%f, %f) \n", x, y);
        System.out.printf("%d Verticies \n", this.v);
        System.out.println("---------------------------");
        this.v++;
        point(x,y);
    } else {
        System.out.println("Test Complete");
        this.shape.endShape(CLOSE);
        this.running = false;
    }
}


Boolean fieldComplete(float x, float y) {
    if (this.v < 20) {
        return false;
    }
    if ((x > this.startx-15 && x < this.startx + 15) && (y > this.starty-15 && y < this.starty+15)) {
        return true;
    }
    return false;

}
