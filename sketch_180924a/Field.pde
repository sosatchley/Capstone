
class Field {
    HUD hud;
    Boolean begun;
    Boolean drawing;
    Boolean complete;
    PShape shape;
    PShape start;
    float startx;
    float starty;
    PVector minX;
    PVector maxX;
    PVector minY;
    PVector maxY;
    int v;
    Agent agent;
    // Util u = new Util();


    Field(Agent agent) {
        this.agent = agent;
        this.v = 0;
        this.begun = false;
        this.drawing = false;
        this.complete = false;
    }

    void startField(HUD hud) {
        this.hud = hud;
        this.hud.fieldStarter.setOn();
        this.startx = this.agent.getAxle().pos.x;
        this.starty = this.agent.getAxle().pos.y;
        this.minX = null;
        this.maxX = null;
        this.minY = null;
        this.maxY = null;
        stroke(255, 0, 0);
        noFill();
        this.start = createShape(RECT, this.startx-15,this.starty-15, 30, 30);
        this.shape = createShape();
        this.shape.beginShape();
        this.shape.stroke(112, 143, 250);
        this.drawing = true;
        this.begun = true;
    }

    void render() {
        if (this.drawing) {
            // pushMatrix();
            shape(this.start);
            float x = this.agent.getAxle().pos.x;
            float y = this.agent.getAxle().pos.y;
            // scale(2);
            // translate(x, y);
            updateShape(x, y);
            // popMatrix();
        }
        if (this.shape != null) {
            shape(this.shape);
        }
    }

    void updateShape(float x, float y) {
        // FIXME: Something about where edge of field is drawn in relation to first pass
        //              Left Wheel? Draw field remaining after first pass?
        //              Right Wheel? Draw entire field, begin showing coverage during first pass?
        if (!complete(x, y)) {
            this.shape.vertex(x, y);
            this.v++;
            point(x,y);
        }
    }

    Boolean complete(float x, float y) {
        if (this.v < 200) {
            return false;
        }
        if (( x > this.startx-15 && x < this.startx + 15) && (y > this.starty-15 && y < this.starty + 15)) {
            this.shape.fill(87, 43, 163, 50);
            this.shape.endShape(CLOSE);
            for (int i = 0; i < this.shape.getVertexCount()-1; i++) {
                PVector vertex = this.shape.getVertex(i);
                if (this.minX == null || this.minX.x > vertex.x) {
                    this.minX = vertex;
                }
                if (this.maxX == null || this.maxX.x < vertex.x) {
                    this.maxX = vertex;
                }
                if (this.minY == null || this.minY.y > vertex.y) {
                    this.minY = vertex;
                }
                if (this.maxY == null || this.maxY.y < vertex.y) {
                    this.maxY = vertex;
                }
            }
            this.drawing = false;
            this.complete = true;
            this.hud.fieldStarter.setOff();
            this.hud.resetView.mousePressed();
            this.hud.resetView.mouseReleased();
            this.hud.followToggle.setLock(false);
            this.hud.followToggle.setValue(false);
            this.hud.resetView.setLock(false);
            this.v = 0;
            println("just 1");
            // this.start.setVisable(false);
            return true;
        }
        return false;
    }
}
