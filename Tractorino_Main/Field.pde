
class Field {
    Agent agent;
    HUD hud;

    PShape shape;
    PShape start;
    PShape cutPath;

    Boolean begun;
    Boolean drawing;
    Boolean complete;

    int side;
    float xScale;
    float yScale;

    float minX;
    float maxX;
    float minY;
    float maxY;
    PVector center;
    float startx;
    float starty;
    Boolean cursorHasExited;
    float fieldWidth;
    float fieldHeight;

    Field(Agent agent) {
        this.agent = agent;
        this.begun = false;
        this.drawing = false;
        this.complete = false;
    }

    void startField(HUD hud) {
        this.hud = hud;
        this.hud.fieldStarter.setOn();
        this.hud.currentView = ViewMode.FOLLOW;
        this.hud.viewButton.setLock(true);
        this.hud.viewButton.setLabel("Follow");
        this.startx = mouseX;
        this.starty = mouseY;
        this.cursorHasExited = false;
        this.minX = Float.POSITIVE_INFINITY;
        this.maxX = Float.NEGATIVE_INFINITY;
        this.minY = Float.POSITIVE_INFINITY;
        this.maxY = Float.NEGATIVE_INFINITY;
        stroke(255, 0, 0);
        noFill();
        this.start = createShape(RECT, this.startx-15,this.starty-15, 30, 30);
        this.shape = createShape();
        this.shape.beginShape();
        this.cutPath = createShape();
        this.cutPath.beginShape();
        this.shape.stroke(112, 143, 250);
        this.cutPath.stroke(255,50);
        this.cutPath.strokeWeight(18);
        this.drawing = true;
        this.complete = false;
        this.begun = true;

    }

    void render() {
        if (this.drawing) {
            shape(this.start);
            updateShape(mouseX, mouseY);
        }
        if (this.shape != null) {
            shape(this.shape);
            shape(this.cutPath);
        }
    }

    void updateShape(float x, float y) {
        if (!complete(x, y)) {
            this.shape.vertex(x,y);
            updateBoundaries(x, y);
            return;
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

    Boolean complete(float x, float y) {

        if (cursorReturnedToStartingSquare(x, y)) {
            this.shape.fill(87, 43, 163, 80);
            this.shape.endShape(CLOSE);
            println(this.shape.getWidth());
            this.drawing = false;
            this.complete = true;

            this.center = new PVector((this.maxX + this.minX)/2,
                                      (this.maxY + this.minY)/2);
            this.fieldWidth = this.maxX - this.minX;
            this.fieldHeight = this.maxY - this.minY;
            this.xScale = width/this.fieldWidth;
            this.yScale = height/this.fieldHeight;

            this.hud.currentView = ViewMode.CENTER;
            this.hud.viewButton.setLock(false);
            this.hud.viewButton.setLabel("Follow");
            this.hud.fieldStarter.setOff();
            return true;
        }
        return false;
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
