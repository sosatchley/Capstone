
class Field {
    Agent agent;
    HUD hud;

    PShape shape;
    PShape start;

    float startx;
    float starty;
    Boolean drawing;
    Boolean cursorHasExited;

    float minX;
    float maxX;
    float minY;
    float maxY;
    float xScale;
    float yScale;
    PVector center;
    float fieldWidth;
    float fieldHeight;

    Field(float x, float y) {
        this.drawing = true;
        this.cursorHasExited = false;
        this.startx = x;
        this.starty = y;
        setupBoundaries();
        setupStartSquare();
        setupFieldShape();
        // TODO Move path funcitonality to Cutter?
        // this.cutPath = createShape();
        // this.cutPath.beginShape();
        // this.cutPath.stroke(255,50);
        // this.cutPath.strokeWeight(18);
    }

    void render() {
        if (this.drawing) {
            shape(this.start);
            updateShape(mouseX, mouseY);
        }
        if (this.shape != null) {
            shape(this.shape);
        }
    }

    void updateShape(float x, float y) {
        if (!complete(x, y)) {
            this.shape.vertex(x, y);
            updateBoundaries(x, y);
        }
    }

    void updateBoundaries(float x, float y) {
        if (this.minX > x) {
            this.minX = x;
        }
        if (this.maxX < x) {
            this.maxX = x;
        }
        if (this.minY > y) {
            this.minY = y;
        }
        if (this.maxY < y) {
            this.maxY = y;
        }
    }

    void setupBoundaries() {
        this.minX = Float.POSITIVE_INFINITY;
        this.maxX = Float.NEGATIVE_INFINITY;
        this.minY = Float.POSITIVE_INFINITY;
        this.maxY = Float.NEGATIVE_INFINITY;
    }

    Boolean complete(float x, float y) {
        if (cursorReturnedToStartingSquare(x, y)) {
            closeFieldShape();
            setGeometry();
            return true;
        }
        return false;
    }

    void closeFieldShape() {
        this.drawing = false;
        this.shape.fill(87, 43, 163, 80);
        this.shape.endShape(CLOSE);
    }

    void setupFieldShape() {
        this.shape = createShape();
        this.shape.beginShape();
        this.shape.noFill();
        this.shape.stroke(112, 143, 250);
    }

    void setGeometry() {
        this.center = new PVector((this.maxX + this.minX)/2,
                                  (this.maxY + this.minY)/2);
        this.fieldWidth = this.maxX - this.minX;
        this.fieldHeight = this.maxY - this.minY;
        this.xScale = width/this.fieldWidth;
        this.yScale = height/this.fieldHeight;
    }

    void setupStartSquare() {
        this.start = createShape();
        this.start.beginShape();
        this.start.stroke(255, 0, 0);
        this.start.noFill();
        this.start.vertex(this.startx-15, this.starty-15);
        this.start.vertex(this.startx+15, this.starty-15);
        this.start.vertex(this.startx+15, this.starty+15);
        this.start.vertex(this.startx-15, this.starty+15);
        this.start.endShape(CLOSE);
    }

    Boolean cursorReturnedToStartingSquare(float x, float y) {
        if (!cursorHasExited) {
            if (cursorInStartingSquare(x, y)) {
                return false;
            } else {
                cursorHasExited = true;
                return false;
            }
        } else {
            if (cursorInStartingSquare(x, y)) {
                return true;
            } else {
                return false;
            }
        }
    }

    Boolean cursorInStartingSquare(float x, float y) {
        return ((x > this.startx - 15 && x < this.startx + 15) &&
                (y > this.starty - 15 && y < this.starty + 15));
    }
}
