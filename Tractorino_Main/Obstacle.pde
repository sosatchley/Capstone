interface Obstacle {
    void render();
}

class ObstacleRegion extends DrawnRegion implements Obstacle {

    ObstacleRegion() {
        this.strokeColor = color(246, 118, 46);
        this.fillColor = color(210, 57, 57, 80);
    }

    ObstacleRegion(PShape shape) {
        super(shape);
        this.strokeColor = color(246, 118, 46);
        this.fillColor = color(210, 57, 57, 80);
        this.shape.setStroke(strokeColor);
        this.shape.setFill(fillColor);
    }

    void render() {
        super.render();
    }
}

class ObstaclePoint extends DrawnRegion implements Obstacle {

    ObstaclePoint() {
        this.strokeColor = color(210, 57, 57);
    }

    ObstaclePoint(PShape shape) {
        super(shape);
        this.strokeColor = color(210, 57, 57);
        this.shape.setStroke(strokeColor);
        this.shape.setStrokeWeight(verticalResolution/360);
    }

    void render() {
        if (this.waiting) {
            cursor(CROSS);
        } else {
            shape(this.shape);
        }
    }

    @Override
    public void beginDrawing(float x, float y) {
        this.setupFieldShape();
        this.addVertex(x, y);
        this.closeFieldShape();
        this.waiting = false;
        this.drawing = false;
        cursor(ARROW);
        hud.panel.setLock(ControlPanelLock.SHOW);
    }

    @Override
    void setupFieldShape() {
        this.shape = createShape();
        this.shape.beginShape();
        this.shape.noFill();
        this.shape.stroke(strokeColor);
        this.shape.strokeWeight(verticalResolution/360);
    }
}
