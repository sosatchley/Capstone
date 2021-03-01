import java.util.*;

class Field extends DrawnRegion {
    List<Obstacle> obstacles = new ArrayList<Obstacle>();

    Field() {
        this.strokeColor = color(112, 143, 250);
        this.fillColor = color(87, 43, 163, 80);
    }

    Field(PShape shape, List<Obstacle> obstacles) {
        super(shape);
        if (obstacles != null && obstacles.size() > 0) {
            this.addObstacles(obstacles);
        }
        this.strokeColor = color(112, 143, 250);
        this.fillColor = color(87, 43, 163, 80);
        this.shape.setStroke(strokeColor);
        this.shape.setStrokeWeight(1);
        this.shape.setFill(fillColor);
    }

    void render(){
        super.render();
        for (Obstacle ob : this.obstacles) {
            ob.render();
        }
    }

    void addObstacle(Obstacle obstacle) {
        this.obstacles.add(obstacle);
    }

    void addObstacles(List<Obstacle> obstacles) {
        this.obstacles = obstacles;
    }

    List<Obstacle> getObstacles() {
        return this.obstacles;
    }
}
