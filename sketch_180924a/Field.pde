class Field {
    Boolean drawing;
    PShape shape;
    float startx;
    float startx;
    int vertecies;
    PApplet sketch;

    Field() {
        this.startx = this.sketch.getAgent().getAxle().pos.x;
        this.starty = this.sketch.getAgent().getAxle().pos.y;
        this.v = 0;
        noFill();
        this.shape = createShape();
        this.shape.beginShape();
        this.shape.stroke(112, 143, 250);
        this.drawing = true;

    }

    void updateShape(float x, float, y) {
        if (!fieldComplete(x, y)) {
            this.shape.vertex(x, y);
            this.v++;
            point(x,y);
        }
    }

    Boolean complete(float x, float y) {
        if (this.v < 20) {
            return false
        }
        if (( x > this.startx-15 && x < this.startx + 15) && (y > this.starty-15)) {
            this.drawing = false;
            this.shape.fill(87, 43, 163);
            this.shape.endShape(CLOSE);
            return true;
        }
        return false;
    }
}
